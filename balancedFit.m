function outputStruct = balancedFit(RGC1,RGC2,nperms)
nTrain = 6; %How many RGCs from each table are used for each training set

%% create a struct with model constants and starting values (cSize, sSize, CSR, res) 
modelParams.cSize = 22; 
% 22 - The spatial structure of a nonlinear receptive field
% 21.5 - Response Characteristics and receptif field widths of ON-Bipolar cells in the mouse retina
% 20 - Inhibition Decorrelates visual feature represntation in the inner retina
% 40.6 - Two-photon imaging of nonlinear glutamate release dynamics at bipolar cell synapses in the mouse retina

modelParams.sSize = 100;
% 127-170 - Inhibition Decorrelates visual feature represntation in the inner retina
% 73.2 - Two-photon imaging of nonlinear glutamate release dynamics at bipolar cell synapses in the mouse retina

modelParams.CSR = 1;
% 1.12 - Two-photon imaging of nonlinear glutamate release dynamics at bipolar cell synapses in the mouse retina
% 0.65 - .9 - Inhibition Decorrelates visual feature represntation in the inner retina

modelParams.resolution = 5;

% precomputed a 1200 um wide distance image (largest spot size)
[x,y] = ndgrid(-600 : modelParams.resolution : 600);
modelParams.distImage = sqrt(x.^2 + y.^2);

%% set constraints on surround size and CSR
minSize = 25;
maxSize = 400;
minCSR = .4;
maxCSR = 5;

%% set up problem (and normalize parameters)
normalizeFactor = [modelParams.CSR, modelParams.CSR, modelParams.sSize];

problem.x0 = [1,1,1]; %values are normalized to 1
problem.lb = [minCSR, minCSR, minSize] ./ normalizeFactor;
problem.ub = [maxCSR, maxCSR, maxSize,] ./ normalizeFactor;
problem.solver = 'fmincon';
problem.options = optimoptions('fmincon');
%problem.options.OptimalityTolerance = 1e-5;
%problem.options.StepTolerance = 1e-8;

%% get random fitting indices for PixON and ON alpha
r = rand(size(RGC1,1), nperms);
[~, RGC1_inds] = sort(r);
RGC1_inds = RGC1_inds(1:nTrain, :)';
RGC1_inds = num2cell(RGC1_inds,2);

r = rand(size(RGC2,1), nperms);
[~, RGC2_inds] = sort(r);
RGC2_inds = RGC2_inds(1:nTrain, :)';
RGC2_inds = num2cell(RGC2_inds,2);


%% create a table for all of the fits and the values we want to save
fits = table();
fits.sSize = nan(nperms,1);
fits.CSR1 = nan(nperms,1);
fits.CSR2 = nan(nperms,1);
fits.r2 = nan(nperms,1);
fits.exitFlag = nan(nperms,1);
fits.RGC1_inds = RGC1_inds;
fits.RGC2_inds = RGC2_inds;


    for i=1:nperms
        tic

        %% fit to a random subset of RGCs
        fit1 = RGC1(RGC1_inds{i},:);
        fit2 = RGC2(RGC2_inds{i},:);

        %% randomize synapse for each RGC and precompute center image
        fit1.randSyn = cell(nTrain,1);
        fit2.randSyn = cell(nTrain,1);
        fit1.cImg = cell(nTrain,1);
        fit2.cImg = cell(nTrain,1);
        sigma = modelParams.cSize / modelParams.resolution;
        filtSize = 6*ceil(sigma)+1;


        for r = 1:nTrain
            fit1.randSyn{r} = getRandSyns(fit1.trace{r}, modelParams.resolution);
            fit2.randSyn{r} = getRandSyns(fit2.trace{r}, modelParams.resolution);
            fit1.cImg{r} = imgaussfilt(fit1.randSyn{r}, sigma, 'FilterSize', filtSize);
            fit2.cImg{r} = imgaussfilt(fit2.randSyn{r}, sigma, 'FilterSize', filtSize);
        end

        %% run optimization
        problem.objective = @(x)objectiveFunction(x, fit1, fit2, modelParams);
        [solution, err, exitflag] = fmincon(problem);

        objectiveFunction(solution, fit1, fit2, modelParams)



        %% save the fit values
        fits.CSR1(i) = solution(1);
        fits.CSR2(i) = solution(2);
        fits.sSize(i) = solution(3) * modelParams.sSize;
        fits.r2(i) = 1-err;
        fits.exitFlag(i) = exitflag;
        
        display(['fit ' num2str(i) ' of ' num2str(nperms)])
        toc
    end


    outputStruct = struct();
    outputStruct.modelParams = modelParams;
    outputStruct.RGC1 = RGC1;
    outputStruct.RGC2 = RGC2;
    outputStruct.fits = fits;
end