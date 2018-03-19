%%
% Copyright (c) 2011-2017 G. Chliveros
%
% Partially originating from Kovesi's Matlab / GNU Octave functions 
% freely available from: www.peterkoveci.com
%
% Copyright (c) 2008-2015 Peter Kovesi
% Centre for Exploration Targeting
% The University of Western Australia
%
% The Software is provided "as is", without warranty of any kind.
%%

%  [newim, newT] = imTrans(im, T, region, sze);
%
%  Arguments: 
%        im     - The image to be transformed.
%        T      - The 3x3 homogeneous transformation matrix.
%        region - An optional 4 element vector specifying 
%                 [minrow maxrow mincol maxcol] to transform.
%                 This defaults to the whole image if you omit it
%                 or specify it as an empty array [].
%        sze    - An optional desired size of the transformed image
%                 (this is the maximum No of rows or columns).
%                 This defaults to the maximum of the rows and columns
%                 of the original image.
%
%  Returns:
%        newim  - The transformed image.
%        newT   - The transformation matrix that relates transformed image
%                 coordinates to the reference coordinates for use in a
%                 function.
%
%  The region argument is used when one is inverting a perspective
%  transformation of a plane and the vanishing line of the plane lies within
%  the image.  Attempts to transform any part of the vanishing line will
%  position you at infinity.  Accordingly one should specify a region that
%  excludes any part of the vanishing line.
%
%  The sze parameter is optionally used to control the size of the
%  output image.  When inverting a perpective or affine transformation
%  the scale parameter is unknown/arbitrary, and without specifying
%  it explicitly the transformed image can end up being very small 
%  or very large.


function [newim, newT] = imTrans(im, T, region, sze);

if isa(im,'uint8')
    im = double(im);  % Make sure image is double     
end

% Set up default region and transformed image size values
[rows, cols, chan] = size(im);

if ~exist('region', 'var') || isempty(region)
    region = [1 rows 1 cols];    
end

if ~exist('sze', 'var') || isempty(sze)
    sze = max([rows, cols]);
end

if chan == 3    % Transform red, green, blue components separately
    im = im/255;  
    [r, newT] = transformImage(im(:,:,1), T, region, sze);
    [g, newT] = transformImage(im(:,:,2), T, region, sze);
    [b, newT] = transformImage(im(:,:,3), T, region, sze);
    
    newim = repmat(uint8(0),[size(r),3]);
    newim(:,:,1) = uint8(round(r*255));
    newim(:,:,2) = uint8(round(g*255));
    newim(:,:,3) = uint8(round(b*255));
    
else             % if image is greyscale
    [newim, newT] = transformImage(im, T, region, sze);
end

%------------------------------------------------------------

%%
% The internal function that does all the work
function [newim, newT] = transformImage(im, T, region, sze);

[rows, cols] = size(im);

% Cut the image down to the specified region
im = im(region(1):region(2), region(3):region(4));
[rows, cols] = size(im);

% Find where corners go - this sets the bounds on the final image
B = bounds(T,region);
nrows = B(2) - B(1);
ncols = B(4) - B(3);

% Determine any rescaling needed
s = sze/max(nrows,ncols);

S = [s 0 0        % Scaling matrix
     0 s 0
     0 0 1];

T = S*T;
Tinv = inv(T);

% Recalculate the bounds of the new (scaled) image to be generated
B = bounds(T,region);
nrows = B(2) - B(1);
ncols = B(4) - B(3);

% Construct a transformation matrix that relates transformed image
% coordinates to the reference coordinates for use in a function.
% This transformation is just an inverse of a scaling and
% origin shift. 
newT=inv(S - [0 0 B(3); 0 0 B(1); 0 0 0]);

% Set things up for the image transformation.
newim = zeros(nrows,ncols);
[xi,yi] = meshgrid(1:ncols,1:nrows);    % All possible xy coords in the image.

% Transform these xy coords to determine where to interpolate values
% from. Note we have to work relative to x=B(3) and y=B(1).
sxy = homoTrans(Tinv, [xi(:)'+B(3) ; yi(:)'+B(1) ; ones(1,ncols*nrows)]);
xi = reshape(sxy(1,:),nrows,ncols);
yi = reshape(sxy(2,:),nrows,ncols);

[x,y] = meshgrid(1:cols,1:rows);
x = x+region(3)-1; % Offset x and y relative to region origin.
y = y+region(1)-1; 
newim = interp2(x,y,double(im),xi,yi); % Interpolate values from source image.
%%


%%
%---------------------------------------------------------------------
%
% Internal function to perform a transformation on homogeneous points/lines
% The resulting points are normalised to have a homogeneous scale of 1
%
% Usage:
%           t = homoTrans(P,v);
%
% Arguments:
%           P  - 3 x 3 or 4 x 4 transformation matrix
%           v  - 3 x n or 4 x n matrix of points/linesl]
function t = homoTrans(P,v)
    
    [dim,npts] = size(v);
    
    if ~all(size(P)==dim)
        error('Transformation matrix and point dimensions do not match');
    end

    t = P*v;  % Transform

    for r = 1:dim-1     %  Now normalise    
        	t(r,:) = t(r,:)./t(end,:);
    end
    
    t(end,:) = ones(1,npts);
%%

%%
%---------------------------------------------------------------------
%
% Internal function to find where the corners of a region, R
% defined by [minrow maxrow mincol maxcol] are transformed to 
% by transform T and returns the bounds, B in the form 
% [minrow maxrow mincol maxcol]
function B = bounds(T, R)

P = [R(3) R(4) R(4) R(3)      % homogeneous coords of region corners
     R(1) R(1) R(2) R(2)
      1    1    1    1   ];
     
PT = round(homoTrans(T,P)); 

B = [min(PT(2,:)) max(PT(2,:)) min(PT(1,:)) max(PT(1,:))];
%      minrow          maxrow      mincol       maxcol  
%%

%% 
% Internal function that plots a coordinate frame specified 
% by a homogeneous transform 
% Usage: function plotframe(T, len, label, colr)
%
% Arguments:
%    T     - 4x4 homogeneous transform or 3x3 rotation matrix
%    len   - length of axis arms to plot (defaults to 1)
%    label - text string to append to x,y,z labels on axes
%    colr  - Three element array specifying colour to plot axes.
%
%  len, label and colr are optional and default to 1 and '' and [0 0 1]
%  respectively.
function plotframe(T, len, label, colr)

    if all(size(T) == [3,3])  % we have a rotation matrix
        T = [ T      [0;0;0]
              0 0 0     1   ];
    end
    
    if ~all(size(T) == [4,4])
        error('plotframe: matrix is not 4x4')
    end
    
    if ~exist('len','var') || isempty(len)
        len = 1;
    end
    
    if ~exist('label','var') || isempty(label)
        label = '';
    end
    
    if ~exist('colr','var') || isempty(colr)
        colr = [0 0 1];
    end    
    
    % Assume scale specified by T(4,4) == 1
    
    origin = T(1:3, 4);             % 1st three elements of 4th column
    X = origin + len*T(1:3, 1);     % point 'len' units out along x axis
    Y = origin + len*T(1:3, 2);     % point 'len' units out along y axis
    Z = origin + len*T(1:3, 3);     % point 'len' units out along z axis
    
    line([origin(1),X(1)], [origin(2), X(2)], [origin(3), X(3)], 'color', colr);
    line([origin(1),Y(1)], [origin(2), Y(2)], [origin(3), Y(3)], 'color', colr);
    line([origin(1),Z(1)], [origin(2), Z(2)], [origin(3), Z(3)], 'color', colr);
    
    text(X(1), X(2), X(3), ['x' label], 'color', colr);
    text(Y(1), Y(2), Y(3), ['y' label], 'color', colr);
    text(Z(1), Z(2), Z(3), ['z' label], 'color', colr);
%%

%%
% function boundplot()
% Plot bounding region lines on original image
%P = [region(3) region(4) region(4) region(3)
%     region(1) region(1) region(2) region(2)
%      1    1    1    1   ];
%B = round(homoTrans(T,P));
%Bx = B(1,:);
%By = B(2,:);
%Bx = Bx-min(Bx); Bx(5)=Bx(1);
%By = By-min(By); By(5)=By(1);
%show(newim,2), axis xy
%line(Bx,By,'Color',[1 0 0],'LineWidth',2);
% end plot bounding region
%%
