clear
clc
close all

settings.Npts = 100;
settings.circleRadius = 0.5;
settings.rayLength = 0.05;
settings.Nmesh = [100 100];
settings.bounds = [-1 1 -1 1];
settings.sampleCloudRadius = 0.03;

settings.displace = [0.0, 0.04];
settings.deformer = @deformation;

geometry = CreateGeometry(settings);
samplePoints = GetSampleCloud(geometry, settings);
mesh = CreateMesh(settings);
cloud = CreateCandidateInterpolationCloud(settings, geometry, samplePoints, mesh);


[Xs,Ys] = meshgrid(mesh.xNode, mesh.yNode);
[Xc,Yc] = meshgrid(mesh.xCell, mesh.yCell);
dataNode = testFunction(Xs, Ys);
data = testFunction(Xc, Yc);

coeffObj = CreateCoefficients(cloud, samplePoints);
surfaceData = SampleData(coeffObj, cloud, samplePoints, data);
dataAnalytical = testFunction(surfaceData.xSample, surfaceData.ySample);

makeDrawing = true;
showSampledData = true;
if (makeDrawing)
    ff = figure;
    hold on
    %set(h,'LineColor','none')
    [X,Y] = meshgrid(mesh.xNode, mesh.yNode);
    plot(X, Y, X', Y', 'color', [0 0 0])
    plot(geometry.points(1, :), geometry.points(2, :), 'LineWidth', 2)
    plot(samplePoints.sampleLocations(1, :), samplePoints.sampleLocations(2, :), 'ro', 'MarkerSize',4)
    plot(samplePoints.faceCenters(1, :), samplePoints.faceCenters(2, :), 'o', 'MarkerSize',4, 'color', [0.5, 0.5, 1])
    X1 = samplePoints.faceCenters(1, :);
    X2 = samplePoints.sampleLocations(1, :);
    Y1 = samplePoints.faceCenters(2, :);
    Y2 = samplePoints.sampleLocations(2, :);
    plot([X1; X2], [Y1; Y2], 'color', [0 0.4 0]);
    plot(cloud.candidatePointsXY(1, :), cloud.candidatePointsXY(2, :), 'o', 'color', [0 0.8 0.4], 'MarkerSize',3)
    plot(cloud.cellPoints(1, :), cloud.cellPoints(2, :), 'o', 'color', [0.8 0 0])
    surf(Xs, Ys, dataNode  - max(max(dataNode)) - 1);
    c = [0.6; 0.5; 1]*linspace(0.2, 0.5, 50);
    colormap(ff,c');
    pbaspect([1 1 1])
    view(2)
end
if (showSampledData)
    figure
    hold on
    plot(surfaceData.xSample, surfaceData.data)
    plot(surfaceData.xSample, dataAnalytical)
end