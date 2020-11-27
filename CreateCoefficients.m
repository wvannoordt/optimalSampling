function [coeffObj] = CreateCoefficients(cloud, samplePoints)
    Ncoef = size(cloud.candidatePointsXY, 2);
    nInterp = length(cloud.cloudSize);
    coeffObj.coeffs = zeros(Ncoef, 1);
    for idx = 1:nInterp
       n1 = cloud.idxStart(idx);
       n2 = cloud.idxEnd(idx);
       numPoints = cloud.cloudSize(idx);
       x = cloud.candidatePointsXY(1, n1:n2);
       y = cloud.candidatePointsXY(2, n1:n2);
       coeffObj.coeffs(n1:n2) = 1.0 / numPoints;
    end
end

