local config = {
  name: 'snmptrapd',
  registry: 'docker.io',
  repo: 'ciscocx',
};

local build(name) = {
  local step(is_pr) = {
    name: name + if is_pr then '_PR' else '',
    image: 'plugins/gcr',
    settings: {
      registry: config.registry,
      repo: config.repo + '/' + name,
      [if !is_pr then 'auto_tag']: true,
      [if !is_pr then 'json_key']: {
        from_secret: 'gcr_credentials',
      },
      [if is_pr then 'dry_run']: true,
    },
    when: {
      ref: [
        'refs/heads/master',
        'refs/tags/*',
      ],
      event:
        if is_pr then [
          'pull_request',
        ] else [
          'tag',
          'push',
        ],
    },
  },
  steps: [
    step(is_pr=true),
    step(is_pr=false),
  ],
};

local notification_step = {
  name: 'send_notification',
  image: 'plugins/slack',
  settings: {
    webhook: {
      from_secret: 'slack_webhook',
    },
    username: 'Drone CI',
    icon_url: 'https://raw.githubusercontent.com/drone/brand/master/logos/png/dark/drone-logo-png-dark-64.png',
    channel: 'drone-ci',
  },
  when: {
    status: [
      'failure',
    ],
  },
};

[
  {
    kind: 'pipeline',
    name: 'default',
    steps:
      build(config.name).steps
      + [
        notification_step,
      ],
  },
]

// Tip: run `drone jsonnet --stream [--stdout]` to generate `.drone.yml` file for verification

