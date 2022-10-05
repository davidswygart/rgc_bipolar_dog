function fits = fitAndCrossVal(rgcs,fitInds)


%% create a struct with model constants and starting values (cSize, sSize, CSR, res) 
% modelParams.cSize = 22; 
% % 22 - The spatial structure of a nonlinear receptive field
% % 21.5 - Response Characteristics and receptif field widths of ON-Bipolar cells in the mouse retina
% % 20 - Inhibition Decorrelates visual feature represntation in the inner retina
% % 40.6 - Two-photon imaging of nonlinear glutamate release dynamics at bipolar cell synapses in the mouse retina

modelParams.sSize = 100;
% 127-170 - Inhibition Decorrelates visual feature represntation in the inner retina
% 73.2 - Two-photon imaging of nonlinear glutamate release dynamics at bipolar cell synapses in the mouse retina

modelParams.CSR = 1;
% 1.12 - Two-photon imaging of nonlinear glutamate release dynamics at bipolar cell synapses in the mouse retina
% 0.65 - .9 - Inhibition Decorrelates visual feature represntation in the inner retina


%% set constraints on surround size and CSR
minSize = 25;
maxSize = 500;
minCSR = .4;
maxCSR = 5;

%% precomputed a 1200 um wide distance image (largest spot size)
res = 5;
[x,y] = ndgrid(-600 : res : 600);
modelParams.distImage = sqrt(x.^2 + y.^2);

%% set up problem (and normalize parameters)
normalizeFactor = [modelParams.CSR, modelParams.sSize];

problem.x0 = [1,1]; %values are normalized to 1
problem.lb = [minCSR, minSize] ./ normalizeFactor;
problem.ub = [maxCSR, maxSize,] ./ normalizeFactor;
problem.solver = 'fmincon';
problem.options = optimoptions('fmincon');
%problem.options.OptimalityTolerance = 1e-5;
%problem.options.StepTolerance = 1e-8;

%% create a table for all of the fits and the values we want to save
nperms = length(fitInds);

fits = table();
fits.sSize = nan(nperms,1);
fits.CSR = nan(nperms,1);
fits.MAE = nan(nperms,1);
fits.exitFlag = nan(nperms,1);
fits.fitInds = fitInds';
fits.crossVal = cell(nperms,1);


    for i=1:nperms
        tic

        %% run optimization
        fitRgcs = rgcs(logical(fitInds{i}),:);
        problem.objective = @(x)objectiveFunction(x, fitRgcs, modelParams);
        [solution, err, exitflag] = fmincon(problem);

        %objectiveFunction(solution, fit1, fit2, modelParams)



        %% save the fit values
        fits.CSR(i) = solution(1) * normalizeFactor(1);

        fits.sSize(i) = solution(2) * normalizeFactor(2);
        fits.MAE(i) = err;
        fits.exitFlag(i) = exitflag;
        
        display(['fit ' num2str(i) ' of ' num2str(nperms)])
        toc

        %% cross validate
        newParams = modelParams;
        newParams.CSR = fits.CSR(i);
        newParams.sSize = fits.sSize(i);
        fits.crossVal(i) = {calcRgcResp(rgcs, newParams,'plot')};
    end
end