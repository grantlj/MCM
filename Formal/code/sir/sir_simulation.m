function sir = sir_simulation ()
k=13;tau=0.8;t_max=120;
base=imread('base.jpg');
m=size(base,1);n=size(base,2);
a=zeros(m,n);

figure;
imshow(base);

%input coast polygon coordinate.
[x,y]=ginput();
poly_area=calcuate_area(x,y);
disp(['Continent percentage:',num2str(poly_area/m/n*100)]);

%input ebola strating point.
[x,y]=ginput(4);

for i=1:size(x,1)
    a(floor(y(i)),floor(x(i)))=1;
end
close(gcf);

%The density of populiation is propagation to the green rate.
max_pop=-inf;
for i=1:m
    for j=1:n
        if (base(i,j,2)>max_pop)
            max_pop=base(i,j,2);
        end
    end
end

%*****************************************************************************80
%
%% SIR_SIMULATION simulates an SIR model of disease transmission.
%
%  Discussion:
%
%    We assume that a hospital ward comprises an array of M by N beds.
%
%    The status of each patient is recorded as an integer in an array A.
%
%    Susceptible patients, with a status of 0, have never had the disease.
%
%    Infected patients, with a positive status between 1 and K, have
%    had the disease for A(I,J) days.
%
%    Recovered patients, with a status of -1, have had the disease for K
%    days, are no longer infected, and cannot get the disease again.
%
%  Licensing:
%
%    This code is distributed under the GNU LGPL license.
%
%  Modified:
%
%    16 April 2009
%
%  Author:
%
%    John Burkardt
%
%  Reference:
%
%    Dianne OLeary,
%    Models of Infection: Person to Person,
%    Computing in Science and Engineering,
%    Volume 6, Number 1, January/February 2004.
%
%    Dianne OLeary,
%    Scientific Computing with Case Studies,
%    SIAM, 2008,
%    ISBN13: 978-0-898716-66-5,
%    LC: QA401.O44.
%
%  Parameters:
%
%    Input, integer M, N, the number of rows and columns of beds.
%
%    Input, integer A(M,N), status of each patient on day T = 1.
%
%    Input, integer K, the maximum number of days of infection.
%
%    Input, real TAU, the probability of transmission of the disease
%    over one day, due to one neighboring patient who is infected.
%
%    Input, integer T_MAX, the number of days to model.
%
%    Output, real SIR(3,T_MAX), the relative numbers of susceptible,
%    infected, and recovered patients.  The sum of these three values
%    will be 1 for each day.
%
  sir = zeros(3,t_max);

  for t = 1 : t_max
% 
%  Plot the current data.
%
    timestep_display ( m, n, a, k, t,base );
%
%  Compute SIR.
%
    tic
  %  sir(1,t) = sum ( sum ( a == 0 ) );
    sir(2,t) = sum ( sum ( 1 <= a & a <= k ) );
    sir(3,t) = sum ( sum ( a == -1 ) );
    sir(1,t)=poly_area-sir(2,t)-sir(3,t);
%
%  Update the patient status for the next day.
%
    if ( t == t_max )
      break
    end

    a_new = zeros ( m, n );

    for i = 1 : m
      for j = 1 : n
%
%  Recovered patients never change.
%
        if ( a(i,j) == -1 )
          a_new(i,j) = -1;
%
%  Infected, and less than K days, increase by 1.
%
        elseif ( 1 <= a(i,j) & a(i,j) < k )
          a_new(i,j) = a(i,j) + 1;
%
%  Infected K days becomes recovered.
%
        elseif ( a(i,j) == k )
          a_new(i,j) = -1;
%
%  Susceptible, look for infected neighbors.
%
        else

          a_new(i,j) = 0;

          if ( 1 < i & 0 < a(i-1,j) & a(i-1,j) <= k )
            if ( rand ( 1, 1 ) <= tau )
              a_new(i,j) = 1;
            end
          end
          if ( i < m & 0 < a(i+1,j) & a(i+1,j) <= k )
            if ( rand ( 1, 1 ) <= tau )
              a_new(i,j) = 1;
            end
          end
          if ( 1 < j & 0 < a(i,j-1) & a(i,j-1) <= k )
            if ( rand ( 1, 1 ) <= tau )
              a_new(i,j) = 1;
            end
          end
          if ( j < n & 0 < a(i,j+1) & a(i,j+1) <= k )
            if ( rand ( 1, 1 ) <= tau )
              a_new(i,j) = 1;
            end
          end
     
        end

      end
    end 
%
%  Copy new data into A.
%
    a = a_new;
    
    toc;

  end
%
%  Normalize SIR.
%
  sir(1:3,1:t_max) = sir(1:3,1:t_max) / (poly_area);
  save('sir.mat','sir');
  return
end

%calculate polygon(the continent area)
function [s]=calcuate_area(x,y)
x=[x;x(1)];  
y=[y;y(1)];   
s=0;
for i=1:size(x,1)-2
    a=x(i)*y(i+1)-x(i+1)*y(i);
    s=s+a;
end
s=1/2*s;  
end
