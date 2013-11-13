function JacobiBeta11
  setup;

  distribution = ProbabilityDistribution.Beta( ...
    'alpha', 2, 'beta', 2, 'a', -1, 'b', 1);

  assess(@(x) x, ...
    'basis', 'Jacobi', 'order', 1, ...
    'alpha', distribution.alpha - 1, ...
    'beta', distribution.beta - 1, ...
    'a', distribution.a, ...
    'b', distribution.b, ...
    'distribution', distribution);
end
