function assessMonomialAccuracy(varargin)
  setup;

  %
  % Example 3.5 in "Adaptive Smolyak Pseudospectral Approximations"
  % by P. Conrad and Y. Marzouk.
  %
  % NOTE: The difference between the level enumeration used in the
  % code and the one used in the above paper is into account here
  % with (5 - 1).
  %
  options = Options( ...
    'dimensionCount', 2, ...
    'rule', 'GaussLegendre', ...
    'a', -1, 'b', 1, ...
    'level', 5 - 1, ...
    'order', 8 + 4, ...
    'method', 'sparse', ...
    'growth', @(level) 2^level, ...
    varargin{:});

  display(options, 'Setup');

  rule = options.fetch('rule');
  dimensionCount = options.dimensionCount;
  order = options.fetch('order');

  x = sym('x%d', [ 1, dimensionCount ]);
  assume(x, 'real');

  indexes = Utils.indexTotalOrderSpace(dimensionCount, order);
  monomialCount = size(indexes, 1);

  monomial1D = sym(zeros(1, order + 1));
  for i = 0:order
    monomial1D(i + 1) = x(1)^i;
  end

  monomialND = monomial1D(indexes(:, 1) + 1);
  for i = 2:dimensionCount
    monomial1D = subs(monomial1D, x(i - 1), x(i));
    monomialND = monomialND .* monomial1D(indexes(:, i) + 1);
  end

  quadrature = Quadrature.(rule)(options);

  nodes = quadrature.nodes;
  weights = quadrature.weights;

  function result_ = evaluateMonomialAtNodes(i_)
    f_ = regexprep(char(monomialND(i_)), '([\^\*\/])', '.$1');
    f_ = regexprep(f_, '\<x(\d+)\>', 'nodes(:,$1)');
    result_ = eval(f_);
  end

  fprintf('\n');
  fprintf('%20s%20s%20s%20s\n', 'Monomial', 'Computed', ...
    'Expected', 'Difference');
  for i = 1:monomialCount
    computed = sum(evaluateMonomialAtNodes(i) .* weights);
    expected = computeExact(rule, indexes(i, :), options);
    error = abs(computed - expected);
    fprintf('%20s%20e%20e%20e', char(monomialND(i)), ...
      computed, expected, error);
    if error > sqrt(eps), fprintf(' [!]'); end
    fprintf('\n');
  end
end

function values = computeExact(rule, index, options)
  values = zeros(size(index));
  switch rule
  case 'GaussHermite'
    I = index == 0;
    values(I) = 1;
    I = ~I & (mod(index, 2) == 0);
    values(I) = factorial2(double(index(I)) - 1);
  case 'GaussLegendre'
    for i = 1:numel(index)
      k = double(index(i));
      values(i) = sum((options.a).^(0:k) .* (options.b).^(k - (0:k))) / (k + 1);
    end
  otherwise
    assert(false);
  end
  values = prod(values, 2);
end

function f = factorial2(n)
  s = size(n);
  n = n(:);

  p = cos(pi * n) - 1;

  f = 2.^((-p + n + n) / 4) .* pi.^(p / 4) .* gamma(1 + n / 2);

  p = find(round(n) == n & imag(n)==0 & real(n) >=- 1);
  if ~isempty(p), f(p) = round(f(p)); end

  p = find(round(n / 2) == (n / 2) & imag(n) == 0 & real(n) < -1);
  if ~isempty(p), f(p) = Inf; end

  f = reshape(f, s);
end