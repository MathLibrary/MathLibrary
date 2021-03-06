function construct(this, options)
  verbose = options.get('verbose', false);

  if verbose
    printf = @(varargin) fprintf(varargin{:});
  else
    printf = @(varargin) [];
  end

  %
  % Deciding about the input data.
  %
  if options.has('nodes')
    nodes = options.nodes;
    [nodeCount, inputCount] = size(nodes);
  else
    inputCount = options.get('inputCount', 1);
    nodeCount = options.get('nodeCount', 10 * inputCount);
    nodes = lhsdesign(nodeCount, inputCount);
  end

  %
  % Deciding about the output data.
  %
  if options.has('responses')
    responses = options.responses;
  else
    target = options.target;
    printf('Gaussian process: collecting data (%d nodes)...\n', nodeCount);
    time = tic;
    responses = target(nodes);
    printf('Gaussian process: done in %.2f seconds.\n', toc(time));
  end

  %
  % Noisy?
  %
  noise = options.get('noiseVariance', 0);
  if isscalar(noise) && noise ~= 0
    noise = diag(noise * ones(1, nodeCount));
  end

  kernel = options.kernel;

  printf('Gaussian process: processing the data (%d inputs, %d outputs)...\n', ...
    inputCount, size(responses, 2));
  time = tic;

  %
  % Normalize the data.
  %
  nodeMean = mean(nodes);
  nodeDeviation = std(nodes);

  responseMean = mean(responses);
  responseDeviation = std(responses);

  nodes = (nodes - repmat(nodeMean, nodeCount, 1)) ./ ...
    repmat(nodeDeviation, nodeCount, 1);
  responses = (responses - repmat(responseMean, nodeCount, 1)) ./ ...
    repmat(responseDeviation, nodeCount, 1);

  %
  % Optimize the parameters.
  %
  if kernel.has('parameters')
    if kernel.has('lowerBound') || kernel.has('upperBound')
      parameters = optimize(nodes, responses, kernel, noise, options);
    else
      parameters = kernel.parameters;
    end
  else
    parameters = [];
  end

  %
  % Compute correlations between the nodes.
  %
  I = Utils.constructPairIndex(nodeCount);
  K = kernel.compute(nodes(I(:, 1), :)', nodes(I(:, 2), :)', parameters);
  K = Utils.symmetrizePairIndex(K, I);

  %
  % Compute the multiplier of the mean of the posterior.
  %
  inverseK = inv(K + noise);
  inverseKy = inverseK * responses;

  printf('Gaussian process: done in %.2f seconds.\n', toc(time));

  %
  % Save everything.
  %
  this.nodeMean = nodeMean;
  this.nodeDeviation = nodeDeviation;

  this.responseMean = responseMean;
  this.responseDeviation = responseDeviation;

  this.nodes = nodes;
  this.kernel = kernel;
  this.parameters = parameters;

  this.inverseK = inverseK;
  this.inverseKy = inverseKy;
end
