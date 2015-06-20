require 'uri'

Puppet::Type.newtype(:yumrepo) do
  @doc = "The client-side description of a yum repository. Repository
    configurations are found by parsing `/etc/yum.conf` and
    the files indicated by the `reposdir` option in that file
    (see `yum.conf(5)` for details).

    Most parameters are identical to the ones documented
    in the `yum.conf(5)` man page.

    Continuation lines that yum supports (for the `baseurl`, for example)
    are not supported. This type does not attempt to read or verify the
    exinstence of files listed in the `include` attribute."

  # Ensure yumrepos can be removed too.
  ensurable
  # Doc string for properties that can be made 'absent'
  ABSENT_DOC="Set this to `absent` to remove it from the file completely."
  # False can be false/0/no and True can be true/1/yes in yum.
  YUM_BOOLEAN=/(True|False|0|1|No|Yes)/i
  YUM_BOOLEAN_DOC="Valid values are: False/0/No or True/1/Yes."

  VALID_SCHEMES = %w[file http https ftp]

  newparam(:name, :namevar => true) do
    desc "The name of the repository.  This corresponds to the
     `repositoryid` parameter in `yum.conf(5)`."
  end

  newparam(:target) do
    desc "The filename to write the yum repository to."

    defaultto :absent
  end

  newproperty(:descr) do
    desc "A human-readable description of the repository.
      This corresponds to the name parameter in `yum.conf(5)`.
      #{ABSENT_DOC}"

    newvalues(/.*/, :absent)
  end

  newproperty(:mirrorlist) do
    desc "The URL that holds the list of mirrors for this repository.
      #{ABSENT_DOC}"

    newvalues(/.*/, :absent)
    validate do |value|
      next if value.to_s == 'absent'
      parsed = URI.parse(value)

      unless VALID_SCHEMES.include?(parsed.scheme)
        raise "Must be a valid URL"
      end
    end
  end

  newproperty(:baseurl) do
    desc "The URL for this repository. #{ABSENT_DOC}"

    newvalues(/.*/, :absent)
    validate do |value|
      next if value.to_s == 'absent'

      value.split(/\s+/).each do |uri|

        parsed = URI.parse(uri)

        unless VALID_SCHEMES.include?(parsed.scheme)
          raise "Must be a valid URL"
        end
      end
    end
  end

  newproperty(:enabled) do
    desc "Whether this repository is enabled.
    #{YUM_BOOLEAN_DOC}
    #{ABSENT_DOC}"

    newvalues(YUM_BOOLEAN, :absent)
  end

  newproperty(:gpgcheck) do
    desc "Whether to check the GPG signature on packages installed
      from this repository.
      #{YUM_BOOLEAN_DOC}
      #{ABSENT_DOC}"

    newvalues(YUM_BOOLEAN, :absent)
  end

  newproperty(:repo_gpgcheck) do
    desc "Whether to check the GPG signature on repodata.
      #{YUM_BOOLEAN_DOC}
      #{ABSENT_DOC}"

    newvalues(YUM_BOOLEAN, :absent)
  end

  newproperty(:gpgkey) do
    desc "The URL for the GPG key with which packages from this
      repository are signed. #{ABSENT_DOC}"

    newvalues(/.*/, :absent)
    validate do |value|
      next if value.to_s == 'absent'

      value.split(/\s+/).each do |uri|

        parsed = URI.parse(uri)

        unless VALID_SCHEMES.include?(parsed.scheme)
          raise "Must be a valid URL"
        end
      end
    end
  end

  newproperty(:include) do
    desc "The URL of a remote file containing additional yum configuration
      settings. Puppet does not check for this file's existence or validity.
      #{ABSENT_DOC}"

    newvalues(/.*/, :absent)
    validate do |value|
      next if value.to_s == 'absent'
      parsed = URI.parse(value)

      unless VALID_SCHEMES.include?(parsed.scheme)
        raise "Must be a valid URL"
      end
    end
  end

  newproperty(:exclude) do
    desc "List of shell globs. Matching packages will never be
      considered in updates or installs for this repo.
      #{ABSENT_DOC}"

    newvalues(/.*/, :absent)
  end

  newproperty(:includepkgs) do
    desc "List of shell globs. If this is set, only packages
      matching one of the globs will be considered for
      update or install from this repo. #{ABSENT_DOC}"

    newvalues(/.*/, :absent)
  end

  newproperty(:enablegroups) do
    desc "Whether yum will allow the use of package groups for this
      repository.
      #{YUM_BOOLEAN_DOC}
      #{ABSENT_DOC}"

    newvalues(YUM_BOOLEAN, :absent)
  end

  newproperty(:failovermethod) do
    desc "The failover method for this repository; should be either
      `roundrobin` or `priority`. #{ABSENT_DOC}"

    newvalues(/roundrobin|priority/, :absent)
  end

  newproperty(:keepalive) do
    desc "Whether HTTP/1.1 keepalive should be used with this repository.
      #{YUM_BOOLEAN_DOC}
      #{ABSENT_DOC}"

    newvalues(YUM_BOOLEAN, :absent)
  end

  newproperty(:http_caching) do
    desc "What to cache from this repository. #{ABSENT_DOC}"

    newvalues(/(packages|all|none)/, :absent)
  end

  newproperty(:timeout) do
    desc "Number of seconds to wait for a connection before timing
      out. #{ABSENT_DOC}"

    newvalues(/[0-9]+/, :absent)
  end

  newproperty(:metadata_expire) do
    desc "Number of seconds after which the metadata will expire.
      #{ABSENT_DOC}"

    newvalues(/[0-9]+/, :absent)
  end

  newproperty(:protect) do
    desc "Enable or disable protection for this repository. Requires
      that the `protectbase` plugin is installed and enabled.
      #{YUM_BOOLEAN_DOC}
      #{ABSENT_DOC}"

    newvalues(YUM_BOOLEAN, :absent)
  end

  newproperty(:priority) do
    desc "Priority of this repository from 1-99. Requires that
      the `priorities` plugin is installed and enabled.
      #{ABSENT_DOC}"

    newvalues(/.*/, :absent)
    validate do |value|
      next if value.to_s == 'absent'
      unless (1..99).include?(value.to_i)
        fail("Must be within range 1-99")
      end
    end
  end

  newproperty(:cost) do
    desc "Cost of this repository. #{ABSENT_DOC}"

    newvalues(/\d+/, :absent)
  end

  newproperty(:proxy) do
    desc "URL to the proxy server for this repository. #{ABSENT_DOC}"

    newvalues(/.*/, :absent)
    validate do |value|
      next if value.to_s == 'absent'
      parsed = URI.parse(value)

      unless VALID_SCHEMES.include?(parsed.scheme)
        raise "Must be a valid URL"
      end
    end
  end

  newproperty(:proxy_username) do
    desc "Username for this proxy. #{ABSENT_DOC}"

    newvalues(/.*/, :absent)
  end

  newproperty(:proxy_password) do
    desc "Password for this proxy. #{ABSENT_DOC}"

    newvalues(/.*/, :absent)
  end

  newproperty(:s3_enabled) do
    desc "Access the repo via S3.
      #{YUM_BOOLEAN_DOC}
      #{ABSENT_DOC}"

    newvalues(YUM_BOOLEAN, :absent)
  end

  newproperty(:sslcacert) do
    desc "Path to the directory containing the databases of the
      certificate authorities yum should use to verify SSL certificates.
      #{ABSENT_DOC}"

    newvalues(/.*/, :absent)
  end

  newproperty(:sslverify) do
    desc "Should yum verify SSL certificates/hosts at all.
      #{YUM_BOOLEAN_DOC}
      #{ABSENT_DOC}"

    newvalues(YUM_BOOLEAN, :absent)
  end

  newproperty(:sslclientcert) do
    desc "Path  to the SSL client certificate yum should use to connect
      to repos/remote sites. #{ABSENT_DOC}"

    newvalues(/.*/, :absent)
  end

  newproperty(:sslclientkey) do
    desc "Path to the SSL client key yum should use to connect
      to repos/remote sites. #{ABSENT_DOC}"

    newvalues(/.*/, :absent)
  end

  newproperty(:metalink) do
    desc "Metalink for mirrors. #{ABSENT_DOC}"

    newvalues(/.*/, :absent)
    validate do |value|
      next if value.to_s == 'absent'
      parsed = URI.parse(value)

      unless VALID_SCHEMES.include?(parsed.scheme)
        raise "Must be a valid URL"
      end
    end
  end

  newproperty(:skip_if_unavailable) do
    desc "Should yum skip this repository if unable to reach it.
      #{YUM_BOOLEAN_DOC}
      #{ABSENT_DOC}"

    newvalues(YUM_BOOLEAN, :absent)
  end
end
