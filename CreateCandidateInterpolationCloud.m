function [cloud] = CreateCandidateInterpolationCloud(settings, geometry, samplePoints, mesh)
    landedPoints = zeros(2, size(samplePoints.sampleLocations, 2));
    candidatePointsIJ = [];
    geomIndices = [];
   
    cloudSize = zeros(size(samplePoints.sampleLocations, 2), 1);
    for nidx = 1:size(samplePoints.sampleLocations, 2)
       x = samplePoints.sampleLocations(:, nidx)';
       n = samplePoints.normals(:, nidx);
       ll = settings.bounds(1:2:3);
       uu = settings.bounds(2:2:4);
       dd = uu-ll;
       NN = settings.Nmesh;
       ijcell = 1+floor(NN.*(x - ll)./dd);
       landedPoints(:, nidx) = [mesh.xCell(ijcell(1)) mesh.yCell(ijcell(2))]';
       sradius = settings.sampleCloudRadius;
       ijCloudLower = 1+floor(NN.*(x - sradius - ll)./dd);
       ijCloudUpper = 1+floor(NN.*(x + sradius - ll)./dd);
       xs = mesh.xCell(ijCloudLower(1):ijCloudUpper(1));
       ys = mesh.yCell(ijCloudLower(2):ijCloudUpper(2));
       [XXs, YYs] = meshgrid(xs, ys);
       dxs = XXs-x(1);
       dys = YYs-x(2);
       norms = (dxs.^2 + dys.^2);
       dots = (dxs*n(1) + dys*n(2))./norms;
       included = norms>0;
       %included = dys>0;
       s = size(included);
       for i=ijCloudLower(1):ijCloudUpper(1)
          for j=ijCloudLower(2):ijCloudUpper(2)
              if (included(i+1-ijCloudLower(1),j+1-ijCloudLower(2)))
                  candidatePointsIJ = [candidatePointsIJ [i;j]];
                  geomIndices = [geomIndices; nidx];
                  cloudSize(nidx) = cloudSize(nidx) + 1;
              end
          end
       end
    end
    %candidatePointsIJ = unique(candidatePointsIJ','rows')';
    cloud.candidatePointsXY = zeros(2, size(candidatePointsIJ, 2));
    for i = 1:size(candidatePointsIJ, 2)
        cloud.candidatePointsXY(1, i) = mesh.xCell(candidatePointsIJ(1, i));
        cloud.candidatePointsXY(2, i) = mesh.yCell(candidatePointsIJ(2, i));
    end
    cloud.cellPoints = landedPoints;
    cloud.candidatePointsIJ = candidatePointsIJ;
    cloud.geomIndices = geomIndices;
    cloud.cloudSize = cloudSize;
    cloud.idxStart = zeros(size(samplePoints.sampleLocations, 2), 1);
    cloud.idxStart(1) = 1;
    for idx = 2:size(samplePoints.sampleLocations, 2)
        cloud.idxStart(idx) = cloud.idxStart(idx-1) + cloudSize(idx-1);
    end
    cloud.idxEnd = cloud.idxStart + cloudSize - 1;
end