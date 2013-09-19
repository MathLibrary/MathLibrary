function plotPolynomialRegression(varargin)
  terms = [ ...
    0, 0; ...
    1, 0; ...
    0, 1; ...
    1, 1; ...
    2, 0; ...
    2, 1; ...
  ];

  assess('leakageOptions', Options('fittingMethod', ...
    'Regression.LogPolynomial', 'terms', terms), varargin{:});
end
