function [ T, output ] = computeWithoutLeakage(this, Pdyn, varargin)
  [ processorCount, stepCount ] = size(Pdyn);
  assert(processorCount == this.processorCount);

  C = this.C;
  E = this.E;
  F = this.F;
  Tamb = this.ambientTemperature;

  Q = F * Pdyn;
  X = Q(:, 1);

  T = zeros(processorCount, stepCount);
  T(:, 1) = C * X + Tamb;

  for i = 2:stepCount
    X = E * X + Q(:, i);
    T(:, i) = C * X + Tamb;
  end

  output = struct;
end
