function timestep_display ( m, n, a, k, t,base )

%*****************************************************************************80
%
%% TIMESTEP_DISPLAY displays the SIR status of all patients at one timestep.
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
%    The dynamics for how the disease starts and spreads are handled elsewhere.
%    This routine simply displays the patient status on a given day.
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
%    Dianne O'Leary,
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
%    Input, integer A(M,N), the status of each patient:
%     0, "Susceptible", display as WHITE.
%     1 through K, "Infected", display as shades of RED.
%    -1, "Recovered", display as GRAY.
%
%    Input, integer K, the maximum number of days of infection.
%
%    Input, integer T, the index of the current day.
%

%
%  Clear the graphics frame.
%
  clf
  fig=zeros(m,n,3);
  for i=1:m
      for j=1:n
          if (a(i,j)==0)
           % fig(i,j,:)=[0,1,1];
           % continue;
         %  base(i,j,:)=[1,1,1];
          % continue;
          end
          
          if (a(i,j)>0)
            base(i,j,:)=[1,0,0]*255;
            continue;
          end
          
          if (a(i,j)==-1)
            base(i,j,:)=[1,0,1]*255;
          end
      end
  end
%  figure('Visible','on');
 % h=figure;
 imshow(base);
 hold on;
 %imshow(fig);
 title_string = sprintf ( 'Ebola status at day T = %d', t );

  title ( title_string )
%
%  Choose the aspect ratio and other plot details.
%
%  axis ( [ x_axes_min, x_axes_max, y_axes_min, y_axes_max] );
 % axis equal
 % axis tight

  hold off
  saveas(gcf,['spread_figure/DAY_',num2str(t),'.jpg']);
  close(gcf);
 % input ( 'Press return' );

  %return
end
