function [geomout] = CreateGeometry(settings)
    geomout.Name = 'geometry';
    N = settings.Npts;
    geomout.numPoints = N+1;
    geomout.points = zeros(2, N+1);
    r = settings.circleRadius;
    theta = linspace(0, 2*pi, N+1);
    geomout.points(1,:) = r*cos(theta);
    geomout.points(2,:) = r*sin(theta);
    for i = 1:N+1
        geomout.points(:,i) = settings.deformer(geomout.points(:,i));
    end
    geomout.points(1,:) = geomout.points(1,:) + settings.displace(1);
    geomout.points(2,:) = geomout.points(2,:) + settings.displace(2);
end