classdef LeakagePower < handle
  properties (SetAccess = 'private')
    toString

    parameters
    parameterCount

    reference

    compute
    isLinearized
  end

  properties (Access = 'private')
    fit
    powerScale
  end

  methods
    function this = LeakagePower(varargin)
      options = Options(varargin{:});

      referencePower = options.fetch('referencePower', NaN);

      this.toString = sprintf('%s(%s)', ...
        class(this), Utils.toString(options));

      filename = File.temporal( ...
        [ 'LeakagePower_', DataHash(this.toString), '.mat' ]);

      if File.exist(filename)
        load(filename);
      else
        fit = Utils.instantiate( ...
          options.fittingMethod, options, 'targetName', 'I');
        save(filename, 'fit', '-v7.3');
      end

      this.parameters = options.parameters;
      this.parameterCount = length(this.parameters);

      assert(this.parameterCount == fit.parameterCount);

      this.fit = fit;

      %
      % Compute the reference values of the parameters.
      %
      reference = cell(1, this.parameterCount);
      for i = 1:this.parameterCount
        reference{i} = options.parameters.(fit.parameterNames{i}).reference;
      end
      this.reference = reference;

      %
      % Compute the power scale if needed.
      %
      if isnan(referencePower)
        powerScale = 1;
      else
        powerScale = referencePower / fit.compute(reference{:});
      end
      this.powerScale = powerScale;

      %
      % Construct the evaluation function.
      %
      this.compute = @(varargin) powerScale * fit.compute(varargin{:});
      this.isLinearized = false;
    end

    function varargout = assign(this, varargin)
      varargout = cell(1, nargout);
      [ varargout{:} ] = this.fit.assign( ...
        varargin{:}, 'reference', this.reference);
    end

    function plot(this, varargin)
      plot(this.fit, varargin{:});
    end

    function result = parameterSweeps(this)
      result = this.fit.parameterSweeps;
    end
  end
end
