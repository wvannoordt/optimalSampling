function [sampleObj] = SampleData(coeffObj, cloud, samplePoints, data)

    nSample = size(cloud.cloudSize, 1);
    sampleObj.data = zeros(nSample, 1);
    sampleObj.xFace = zeros(nSample, 1);
    sampleObj.yFace = zeros(nSample, 1);
    sampleObj.xSample = zeros(nSample, 1);
    sampleObj.ySample = zeros(nSample, 1);
    for idx = 1:nSample
        sampleObj.xFace(idx) = samplePoints.faceCenters(1, idx);
        sampleObj.yFace(idx) = samplePoints.faceCenters(2, idx);
        sampleObj.xSample(idx) = samplePoints.sampleLocations(1, idx);
        sampleObj.ySample(idx) = samplePoints.sampleLocations(2, idx);
        n1 = cloud.idxStart(idx);
        n2 = cloud.idxEnd(idx);
        for sampleIdx = n1:n2
            i = cloud.candidatePointsIJ(1,sampleIdx);
            j = cloud.candidatePointsIJ(2,sampleIdx);
            dataLoc = data(j, i);
            coeff   = coeffObj.coeffs(sampleIdx);
            sampleObj.data(idx) = sampleObj.data(idx) + dataLoc * coeff;
        end
    end
end

