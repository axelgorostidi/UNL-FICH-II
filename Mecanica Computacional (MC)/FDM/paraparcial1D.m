% diferencias finitas 1D

%FDM M�todo de diferencias finitas para la ecuaci�n de transporte
xlim = [0 1]; %   xlim: vector con los l�mites del intervalo [x0,xn] 
nodos = 5 %   nodos: cantidad de nodos
k = 1;%   k: valor del t�rmino difuso
c = 0;%   c: valor del t�rmino reactivo
v = 5;%   v: valor del t�rmino convectivo
Q = ones(nodos,1)*0;%   Q: valor de la fuente
r = [100 5]%   r: vector con los valores de contorno
tipo = ['d' 'n']%   tipo: vector con la condici�n de contorno
%         d -> Dirichlet
%         n -> Neumann
%         r -> Robin
hrobin = 1.2;%   hrobin: constante h asociada a la condici�n de Robin
tinf = 30;%   tinf: constante Tinf asociada a la condici�n de Robin
p = 1;%   p: presi�n, rho
Cp = 1;%   Cp: calor espec�fico
theta = 1;%   theta: par�metro temporal
%          0  -> Forward-Euler (esquema expl�cito)
%          1  -> Backward-Euler (esquema impl�cito)
%         1/2 -> Crank-Nicolson (esquema semi-impl�cito)
%         -1  -> No hay t�rmino temporal
nt = 1;%   nt: numero de iteraciones para esquema temporal
tol = 10e-3;%   tol: tolerancia de error para esquema temporal
t0 = 0;%   t0: valor inicial de la temperatura
dx = (xlim(2)-xlim(1))/(nodos-1);
t0 = 100-5.*[xlim(1):dx:xlim(2)]'; % valor de t en tiempo n

[K,f,phi,q] = FDM_1D(xlim,nodos,k,c,v,Q,r,tipo,hrobin,tinf,p,Cp,theta,nt,tol,t0);
