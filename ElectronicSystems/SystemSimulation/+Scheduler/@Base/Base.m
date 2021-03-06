classdef Base < handle
  properties (SetAccess = 'private')
    platform
    application

    childMapping
    parentMapping

    profile
  end

  methods
    function this = Base(varargin)
      options = Options(varargin{:});

      this.platform = options.platform;
      this.application = options.application;

      taskCount = length(this.application);

      this.childMapping = cell(1, taskCount);
      this.parentMapping = cell(1, taskCount);

      for id = 1:taskCount
        this.childMapping{id} = ...
          find(this.application.links(id, :));
        this.parentMapping{id} = ...
          transpose(find(this.application.links(:, id)));
      end

      this.profile = SystemProfile.Average( ...
        'platform', this.platform, ...
        'application', this.application);
    end

    function output = compute(this, varargin)
      [mapping, priority, order, startTime, executionTime] = ...
        this.construct(varargin{:});

      output = [mapping; priority; order; startTime; executionTime];
    end

    function schedule = decode(~, output)
      schedule = struct;
      schedule.mapping = output(1, :);
      schedule.priority = output(2, :);
      schedule.order = output(3, :);
      schedule.startTime = output(4, :);
      schedule.executionTime = output(5, :);
    end
  end

  methods (Abstract, Access = 'protected')
    [mapping, priority, order, startTime, executionTime] = ...
      construct(this, varargin);
  end
end
