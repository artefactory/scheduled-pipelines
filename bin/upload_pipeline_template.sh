#!/bin/bash -e

path_to_pipeline_templates_directory=$1
path_to_pipeline_templates_directory="${path_to_pipeline_templates_directory%/}"

region=$(grep 'region' scheduled_pipelines_config.yaml | sed -n 's/.*region:[^a-zA-Z0-9-]*\([a-zA-Z0-9-]*\).*/\1/p')
project_id=$(grep 'id' scheduled_pipelines_config.yaml | sed -n 's/.*id:[^a-zA-Z0-9-]*\([a-zA-Z0-9-]*\).*/\1/p')
repository_name=$(grep 'repository_name' scheduled_pipelines_config.yaml | sed -n 's/.*repository_name:[^a-zA-Z0-9-]*\([a-zA-Z0-9-]*\).*/\1/p')

echo "Artifact Registry: ${region}-kfp.pkg.dev/${project_id}/${repository_name}"

for template_file in $path_to_pipeline_templates_directory/*.yaml; do
    if [ ! -f "$template_file" ]; then
        echo "No pipeline template found in $path_to_pipeline_templates_directory"
        exit 1
    else
        echo "Uploading pipeline template $template_file..."
        curl -X POST \
            -H "Authorization: Bearer $(gcloud auth print-access-token)" \
            -F tags=latest \
            -F content=@${template_file} \
            https://${region}-kfp.pkg.dev/${project_id}/${repository_name}
    fi
done
