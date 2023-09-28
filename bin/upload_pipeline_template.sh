#!/bin/bash -e

region=$(yq -e .project.region scheduled_pipelines_config.yaml)
project_id=$(yq -e .project.id scheduled_pipelines_config.yaml)
repository_name=$(yq -e .project.repository_name scheduled_pipelines_config.yaml)

artifact_registry_url=https://${region}-kfp.pkg.dev/${project_id}/${repository_name}

echo "Artifact Registry: ${artifact_registry_url}"

for template_file in pipelines/*.yaml; do
    if [ ! -f "$template_file" ]; then
        echo "No pipeline template found in pipelines directory."
        exit 1
    else
        echo "Uploading pipeline template $template_file..."
        curl -X POST \
            -H "Authorization: Bearer $(gcloud auth print-access-token)" \
            -F tags=latest \
            -F content=@"${template_file}" \
            "${artifact_registry_url}"
    fi
done
