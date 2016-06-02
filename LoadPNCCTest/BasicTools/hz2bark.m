function bark=hz2bark(hz)
dummy=hz/600.;
bark=6.0*log(dummy+sqrt(dummy.^2+1.0));

%dummy=hz/600.;
%bark=6.7*log(dummy+sqrt(dummy.^2+1.0));

%bark = ( 26.81 * hz ) ./ ( hz + 1960 ) - 0.53 ;