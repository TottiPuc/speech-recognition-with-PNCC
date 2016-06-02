function hz=bark2hz(bark)
dummy=bark/6.0;
hz=300.0*(exp(dummy)-exp(-dummy));

%dummy=bark/6.7;
%hz=300.0*(exp(dummy)-exp(-dummy));

%hz = 1960 ./ ( 26.81 ./ ( bark + 0.53 ) - 1 ) ;