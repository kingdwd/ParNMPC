deltaTau = T/N; % step size
varibleUXP      =  num2cell([u;x;p]);
if muDim == 0
    H([unknowns;p]) = L(varibleUXP{:}) +...
                      lambda.' * f(varibleUXP{:});
else
    H([unknowns;p]) = L(varibleUXP{:}) +...
                  lambda.' * f(varibleUXP{:})+...
                  mu.' * C(varibleUXP{:});
end
Hu = jacobian(H,u);
Hx = jacobian(H,x);

varibleLambdaMuUXP =  num2cell([lambda;mu;u;x;p]);
if muDim == 0
    KKT  = [f(varibleUXP{:})*deltaTau + xPrev - x;...
            Hu(varibleLambdaMuUXP{:}).'*deltaTau;...
            lambdaNext - lambda + Hx(varibleLambdaMuUXP{:}).'*deltaTau];
else
    KKT  = [f(varibleUXP{:})*deltaTau + xPrev - x;...
            C(varibleUXP{:})*deltaTau;...
            Hu(varibleLambdaMuUXP{:}).'*deltaTau;...
            lambdaNext - lambda + Hx(varibleLambdaMuUXP{:}).'*deltaTau];
end
% Convert symbolic function to Matlab function
disp('Generating KKT function file......');
matlabFunction(KKT,...
        'File','GEN_Func_KKT',...
        'Vars',{unknowns;xPrev;lambdaNext;p});
disp('Done...');
