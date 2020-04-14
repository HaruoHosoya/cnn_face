
function ellipsePixels = creatEllipse(imageSize, radiusX, radiusY, centerX, centerY)
% Create a logical image of an ellipse with specified
% semi-major and semi-minor axes, center, and image size.
% First create the image.
imageSizeX = imageSize;
imageSizeY = imageSize;
[columnsInImage rowsInImage] = meshgrid(1:imageSizeX, 1:imageSizeY);
% Next create the ellipse in the image.
% centerX = 112;
% centerY = 112;
% radiusX = 50;
% radiusY = 50;
ellipsePixels = (rowsInImage - centerY).^2 ./ radiusY^2 ...
    + (columnsInImage - centerX).^2 ./ radiusX^2 <= 1;
% ellipsePixels is a 2D "logical" array.
% Now, display it.
% figure;
% image(ellipsePixels) ;
% colormap([0 0 0; 1 1 1]);
% title('Binary image of a ellipse', 'FontSize', 20);