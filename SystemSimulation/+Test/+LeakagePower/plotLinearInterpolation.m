function plotLinearInterpolation(varargin)
  assess('leakageOptions', Options( ...
    'approximation', 'Interpolation.Linear'), ...
    varargin{:});
end
