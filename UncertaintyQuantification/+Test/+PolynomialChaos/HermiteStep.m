function HermiteStep
  setup;

  surrogate = PolynomialChaos('basis', 'Hermite', ...
    'inputCount', 1, 'outputCount', 1, 'order', 10);

  output = surrogate.construct(@(x) problem(x));

  x = linspace(-3, 3).';

  y1 = problem(x);
  y2 = surrogate.evaluate(output, x);

  figure;

  line(x, y1, 'Color', Color.pick(1));
  line(x, y2, 'Color', Color.pick(2));

  ylim([-0.5, 1.5]);
end

function y = problem(x)
  y = ones(size(x));
  y(x > -1/2) = 0;
end
