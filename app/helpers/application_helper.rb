# frozen_string_literal: true

module ApplicationHelper
  include Auth

  def link_to_file_commit_path(check, file_path)
    relative_path = file_path.sub(check.repository.temp_repository_path.to_s, '').sub(%r{^/}, '')

    url = "https://github.com/#{check.repository.full_name}/blob/#{check.commit_id}/#{relative_path}"

    link_to relative_path, url,
            target: '_blank',
            rel: 'noopener noreferrer',
            title: relative_path
  end

  def link_to_commit(check)
    return if check.commit_id.blank?

    commit_sha = check.commit_id
    short_sha = commit_sha[0..6] # First 7 chars
    repo_full_name = check.repository.full_name

    url = "https://github.com/#{repo_full_name}/commit/#{short_sha}"

    link_to short_sha, url, target: '_blank', rel: 'noopener noreferrer'
  end
end
