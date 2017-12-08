function [K,f,phi,q] = FDM_1D(xlim,nodos,k,c,v,Q,r,tipo,hrobin,tinf,p,Cp,theta,nt,tol,t0)
%FDM M�todo de diferencias finitas para la ecuaci�n de transporte
%   xlim: vector con los l�mites del intervalo [x0,xn]
%   nodos: cantidad de nodos
%   k: valor del t�rmino difuso
%   c: valor del t�rmino reactivo
%   v: valor del t�rmino convectivo
%   Q: valor de la fuente
%   r: vector con los valores de contorno
%   tipo: vector con la condici�n de contorno
%         d -> Dirichlet
%         n -> Neumann
%         r -> Robin
%   hrobin: constante h asociada a la condici�n de Robin
%   tinf: constante Tinf asociada a la condici�n de Robin
%   p: presi�n
%   Cp: calor espec�fico
%   theta: par�metro temporal
%          0  -> Forward-Euler (esquema expl�cito)
%          1  -> Backward-Euler (esquema impl�cito)
%         1/2 -> Crank-Nicolson (esquema semi-impl�cito)
%         -1  -> No hay t�rmino temporal
%   nt: numero de iteraciones para esquema temporal
%   tol: tolerancia de error para esquema temporal
%   t0: valor inicial de la temperatura

%Espaciado de los nodos
dx = (xlim(2)-xlim(1))/(nodos-1);
dx2 = dx^2;
x = xlim(1):dx:xlim(2);

%Matriz del sistema
K = zeros(nodos);
%Vector del sistema
f = zeros(nodos,1);

%Peclet
Pe = (v*dx)/(2*k);
if (Pe < 1)
    knum = 0;
else
    knum = (v*dx/2)*(1/tanh(Pe) - 1/Pe);
end

%Nodos interiores
for i = 2:nodos-1
    K(i,i-1) = -(k+knum)/dx2 - v/(2*dx);
    K(i,i) = (2*(k+knum))/dx2 + c;
    K(i,i+1) = -(k+knum)/dx2 + v/(2*dx);
end
f(2:end-1) = Q(2:end-1);

%Condici�n de contorno en x0
if (tipo(1) == 'd')
    K(1,1) = 1;
    f(1) = r(1);
elseif (tipo(1) == 'n')
    K(1,1) = (2*k)/dx2 + c;
    K(1,2) = -(2*k)/dx2;
    f(1) = Q(1) - (2/dx + v/k)*r(1);
else
    K(1,1) = (2*hrobin)/dx + (v*hrobin)/k + (2*k)/dx2 + c;
    K(1,2) = -(2*k)/dx2;
    f(1) = Q(1) + (2/dx + v/k)*hrobin*tinf;
end
%Condici�n de contorno en xn:
if (tipo(2) == 'd')
    K(end,end) = 1;
    f(end) = r(2);
elseif (tipo(2) == 'n')
    K(end,end-1) = -(2*k)/dx2;
    K(end,end) = (2*k)/dx2 + c;
    f(end) = Q(end) + (-2/dx + v/k)*r(2);
else
    K(end,end-1) = -(2*k)/dx2;
    K(end,end) = (2*hrobin)/dx - (v*hrobin)/k + (2*k)/dx2 + c;
    f(end) = Q(end) - (-2/dx + v/k)*hrobin*tinf;
end

%Selecci�n del m�todo para resoluci�n
if (theta == -1) %estacionario
    phi = K\f;
%     figure;
%     plot(x,phi,'r');
%     title('Solucion estacionaria');
else
    alfa = k/(p*Cp);
    %dt = min((0.5*dx2)/alfa,dx/v);
    dt = 0.1;
    if (theta == 0) %explicito
        [phi] = fdm_explicito(K,f,nodos,x,r,tipo,p,Cp,dt/2,nt,tol,t0);
    elseif (theta == 1) %implicito
        [phi] = fdm_implicito(K,f,nodos,x,r,tipo,p,Cp,dt,nt,tol,t0);
    elseif (theta == 1/2) %semi-implicito
        [phi] = fdm_semi_implicito(K,f,nodos,x,r,tipo,p,Cp,dt,nt,tol,t0);
    end
end

[q] = flujo_1D(phi,nodos,dx,k,r,tipo,hrobin,tinf);
    
end