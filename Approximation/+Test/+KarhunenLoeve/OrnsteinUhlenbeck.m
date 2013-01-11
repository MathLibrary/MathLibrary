setup;

dimensionCount = 10;
domainBoundary = 1;
correlationLength = 1;
kernel = @(s, t) exp(-abs(s - t) / correlationLength);

kl1 = KarhunenLoeve.OrnsteinUhlenbeck( ...
  'dimensionCount', dimensionCount, ...
  'domainBoundary', domainBoundary, ...
  'correlationLength', correlationLength);

kl2 = KarhunenLoeve.Fredholm( ...
  'kernel', kernel, ...
  'dimensionCount', dimensionCount, ...
  'domainBoundary', domainBoundary);

figure;
line(1:dimensionCount, kl1.values, 'Marker', 'x');
line(1:dimensionCount, kl2.values, 'Marker', 'o');
legend('OrnsteinUhlenbeck', 'Fredholm');

figure;
r = linspace(-domainBoundary, domainBoundary);
for i = 1:dimensionCount
  color = Color.pick(i);
  line(r, kl1.functions{i}(r), 'Color', color, 'Marker', 'x');
  line(r, kl2.functions{i}(r), 'Color', color, 'Marker', 'o');
end

samples = 1e3;
z = randn(samples, dimensionCount);
k = zeros(dimensionCount, length(r));

for i = 1:dimensionCount
  k(i, :) = kl1.functions{i}(r);
end

u = z * diag(sqrt(kl1.values)) * k;

figure;
[ R1, R2 ] = meshgrid(r, r);
C = cov(u);
mesh(R1, R2, C);
hold on;

C = kernel(R1, R2);
plot3(R1, R2, C, 'k.', 'MarkerSize', 10);
