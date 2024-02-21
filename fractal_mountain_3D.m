function [X, Y, Z] = fractal_mountain_3D()
% 3D fractal moutain construction algorithm, step by step display.
%
% Support : nicolas.douillet (at) free.fr, 2017-2019.


n = 6;
z = ones(2^n+1,2^n+1);

d = 2;
z(1,1) = 2;     
z(1,2^n+1) = 2; 
z(2^n+1,1) = 2; 
z(2^n+1,2^n+1) = 2;

% figure;

% Until n steps
for nc = 1:n
  
    Ml = ones(2^(nc-1),2^(nc-1));
    Mc = ones(2^(nc-1),2^(nc-1));

    % Square step
    for j = 1:2^(nc-1)
        for i = 1:2^(nc-1)

            % Looking for the index of the point to compute in z (function of step)
            if i~=1 | j~=1
                ix = (2^(n+1)/2^nc)*(j-1)+(2^n/2^nc)+1;
                iy = (2^(n+1)/2^nc)*(i-1)+(2^n/2^nc)+1;
            elseif i==1 & j==1 % first step distinct from the followings
                ix = (2^n/2^nc)+1;
                iy = ix;
            end
            
            rne = [ix+1,iy-1];
            rno = [ix-1,iy-1];
            rse = [ix+1,iy+1];
            rso = [ix-1,iy+1];

            % Looking for existing points in the around (to compute the average)

            % North-east
            % While point not defined or square limits not reached
            while((rne(1,1)+1)<=2^n+1 & (rne(1,2)-1)>=1 & z(rne(1,1),rne(1,2))==1)
                rne(1,1) = rne(1,1)+1;
                rne(1,2) = rne(1,2)-1;
            end

            % North-west
            % While point not defined or square limits not reached
            while((rno(1,1)-1)>=1 & (rno(1,2)-1)>=1 & z(rno(1,1),rno(1,2))==1 )
                rno(1,1) = rno(1,1)-1;
                rno(1,2) = rno(1,2)-1;
            end

            % South-east
            % While point not defined or square limits not reached
            while((rse(1,1)+1)<=2^n+1 & (rse(1,2)+1)<=2^n+1 & z(rse(1,1),rse(1,2))==1)
                rse(1,1) = rse(1,1)+1;
                rse(1,2) = rse(1,2)+1;
            end

            % South-west
            % While point not defined or square limits not reached
            while((rso(1,1)-1)>=1 & (rso(1,2)+1)<=2^n+1 & z(rso(1,1),rso(1,2))==1)
                rso(1,1) = rso(1,1)-1;
                rso(1,2) = rso(1,2)+1;
            end

            % Computing the mean of the 4 found points (edge)
            moy = (z(rne(1,1),rne(1,2)) + z(rno(1,1),rno(1,2)) + z(rse(1,1),rse(1,2)) + z(rso(1,1),rso(1,2)))/4;

            z(ix,iy) = moy + (rand-0.5)*d;

            % Saving newly created points -> Rhombus
            Ml(i,j) = ix;
            Mc(i,j) = iy;

        end
    end

    % Rhombus step
    for i = 1:2^(nc-1)
        for j = 1:2^(nc-1)

            pas = 2^n/2^nc;
            l = Ml(i,j);
            c = Mc(i,j);

            % Top point
            if(z(l-pas,c)==1) % already defined ?
                if((l-pas)==1) % edge ?
                    moy =(z(l,c)+z(l-pas,c+pas)+z(l-pas,c-pas))/3;
                else
                    moy =(z(l,c)+z(l-2*pas,c)+z(l-pas,c+pas)+z(l-pas,c-pas))/4;
                end
                z(l-pas,c) = moy + (rand-0.5)*d;
            end

            % Right point
            if(z(l,c+pas)==1) % already defined ?
                if((c+pas)==2^n+1) % edge ?
                    moy =(z(l,c)+z(l-pas,c+pas)+z(l+pas,c+pas))/3;
                else
                    moy =(z(l,c)+z(l-pas,c+pas)+z(l+pas,c+pas)+z(l,c+2*pas))/4;
                end
                z(l,c+pas) = moy + (rand-0.5)*d;
            end

            % Bottom point
            if(z(l+pas,c)==1) % already defined ?
                if((l+pas)==2^n+1) % edge ?
                    moy = (z(l,c)+z(l+pas,c-pas)+z(l+pas,c+pas))/3;
                else
                    moy = (z(l,c)+z(l+pas,c-pas)+z(l+pas,c+pas)+z(l+2*pas,c))/4;
                end
                z(l+pas,c) = moy + (rand-0.5)*d;
            end

            % Left point
            if(z(l,c-pas)==1) % already defined ?
                if((c-pas)==1) % edge ?
                    moy = (z(l,c)+z(l-pas,c-pas)+z(l+pas,c-pas))/3;
                else
                    moy = (z(l,c)+z(l-pas,c-pas)+z(l+pas,c-pas)+z(l,c-2*pas))/4;
                end
                z(l,c-pas) = moy  + (rand-0.5)*d;
            end

        end
    end

    % -------------- Step by step display ------------------    

    x = ones(1,2^nc+1);
    y = ones(1,2^nc+1);

    for k = 0:2^nc
        x(1,k+1) = k*(1/2^nc)+1;
    end

    for k = 0:2^nc
        y(1,k+1) = k*(1/2^nc)+1;
    end

    [X,Y] = meshgrid(x,y);

    Z = ones(2^(nc)+1,2^(nc)+1);
    m = [0,1];

    for j = 1:2^n+1
        for i = 1:2^n+1
            if(z(j,i)~=1)
                m(1,1) = m(1,1)+1;
                Z(m(1,2),m(1,1)) = z(j,i);
            end
        end
        
        if(m(1,1)==2^(nc)+1)
            m(1,2) = m(1,2)+1;
        end
        m(1,1) = 0;
    end

    % Smoothing edges
    for i = 1:2^nc+1
        if(Z(i,1)>2) Z(i,1) = 2;
        end
        if(Z(1,i)>2) Z(1,i) = 2;
        end
        if(Z(2^nc+1,i)>2) Z(2^nc+1,i) = 2;
        end
        if(Z(i,2^nc+1)>2) Z(i,2^nc+1) = 2;
        end
    end
    
%     surf(X,Y,Z,'FaceColor','interp','FaceLighting','phong');
%     axis([1 2 1 2 1 3]);
%     shading interp
%     colormap('jet');
%     camlight left;
%     pause(1);

    % ------------------------------------------------------

    d = d/2;
end

end