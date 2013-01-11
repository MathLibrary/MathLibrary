function [ functions, values ] = construct(this, options)
  kernel = options.kernel;
  boundary = options.domainBoundary;
  dimension = options.get('dimensionCount', NaN);

  F = fred(kernel, domain([ -boundary, boundary ]));

  if isnan(dimension)
    dimension = 10;
    maxDimension = 100;
    threshold = options.threshold;

    %
    % Estimate all the eigenvalues based on a few of them.
    %
    L = eigs(F, dimension, 'lm');
    alpha = [ ones(dimension, 1), - (1:dimension)' ] \ log(sqrt(L));
    L = exp(alpha(1)) .* (exp(alpha(2)) .^ (-(1:maxDimension)'));

    dimension = sum(cumsum(L) < threshold * sum(L)) + 1;
  end

  [ V, L ] = eigs(F, dimension, 'lm');

  functions = cell(dimension, 1);
  for i = 1:dimension
    functions{i} = V(:, i);
  end

  values = diag(L);

  this.kernel = kernel;
end
