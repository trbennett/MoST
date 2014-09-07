function [ energy ] = energyFeature( sig )
% energyFeature: this function calculates the energy of the discrete signal
% 'sig'passed to it. 
% sig[in] one dimentional discrete input signal whose energy has to be
% found out.
% energy[out] variable into which the calculated energy is stored into

energy = sum(sig.^2);


end

