function mrf2 = dgmToMrf2(dgm, varargin)
%% Convert a dgm to a pairwise Markov random field
% for use by Mark Schmidt's UGM library
% See mrf2Create for additional optional args
% PMTKgraphicalModel dgm
%
%%
mrf2 = factorGraphToMrf2(dgmToFactorGraph(dgm), varargin{:}); 
end