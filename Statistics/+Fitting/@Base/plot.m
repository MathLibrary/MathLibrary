function plot(this, varargin)
  options = Options(varargin{:});

  parameterCount = this.parameterCount;
  parameters = cell(1, parameterCount);
  index = zeros(1, parameterCount);

  %
  % Assignment of the fixed parameters
  %
  fixedParameters = options.get('fixedParameters', struct);
  for i = 1:parameterCount
    if isfield(fixedParameters, this.parameterNames{i})
      parameters{i} = fixedParameters.(this.parameterNames{i});
    else
      index(i) = i;
    end
  end
  index(index == 0) = [];

  %
  % Construction of the evaluation grids
  %
  switch length(index)
  case 1
    parameters{index} = this.parameterSweeps{index};
  case 2
    [parameters{index}] = ndgrid(this.parameterSweeps{index});
  otherwise
    assert(false);
  end

  %
  % Correction of the dimensionality
  %
  title = '';
  for i = 1:parameterCount
    if ~isempty(title), title = [title, ', ']; end
    title = [title, this.parameterNames{i}];
    if ~any(index == i)
      title = [title, ' = ', String(parameters{i})];
      parameters{i} = parameters{i} * ones(size(parameters{index(1)}));
    end
  end
  target = this.evaluate(parameters{:});

  %
  % Normalization
  %
  if options.has('normalization')
    referenceParameters = this.assign(options.normalization);
    referenceTarget = this.evaluate(referenceParameters{:});
    target = target / referenceTarget;
  end

  %
  % Plotting
  %
  if options.get('figure', true)
    Plot.figure(800, 600);
  end

  switch length(index)
  case 1
    Plot.line(parameters(index), target);
    if options.get('logScale', false)
      set(gca, 'YScale', 'log');
    end
  case 2
    surfc(parameters{index}, target);
    colormap(jet);
    set(gcf, 'Renderer', 'painters')
    if options.get('logScale', false)
      set(gca, 'ZScale', 'log');
    end
    view(-90, 0);
  otherwise
    assert(false);
  end

  if options.has('normalization')
    Plot.dot(referenceParameters{index}, 1);
  end

  grid on;

  Plot.title([this.targetName, '(', title, ')']);

  targetName = this.targetName;
  if options.has('normalization')
    targetName = [targetName, '/', targetName, '_0'];
  end
  if options.get('logScale', false);
    targetName = ['log(', targetName, ')'];
  end
  Plot.label(this.parameterNames{index}, targetName);
end
