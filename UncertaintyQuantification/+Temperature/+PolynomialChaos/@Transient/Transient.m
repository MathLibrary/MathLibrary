classdef Transient < ...
  Temperature.Analytical.Transient & ...
  Temperature.PolynomialChaos.Base

  methods
    function this = Transient(varargin)
      options = Options(varargin{:});
      this = this@Temperature.Analytical.Transient(options);
      this = this@Temperature.PolynomialChaos.Base(options);
    end

    function output = compute(this, varargin)
      output = this.expand(varargin{:});
    end

    function plot(this, varargin)
      this.surrogate.plot(varargin{:});
    end
  end
end