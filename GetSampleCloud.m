function [sampleCloudOut] = GetSampleCloud(geometry, settings)
    rayLength = settings.rayLength;
    sampleCloudOut.faceCenters = 0.5*(geometry.points(:, 1:end-1) + geometry.points(:, 2:end));
    normals =  [0 -1; 1 0] * (geometry.points(:, 2:end) - geometry.points(:, 1:end-1));
    norms = 1.0./vecnorm(normals);
    normals = normals*diag(norms);
    sampleCloudOut.normals = normals;
    sampleCloudOut.sampleLocations = sampleCloudOut.faceCenters - rayLength*normals;
end