
MYPATH_="${BASH_SOURCE[0]}"
MYDIR_="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CACHE_PATH_is_set="/home/$USER/rpitools/cache/.apache_set_done"
source "${MYDIR_}/../../../prepare/colors.bash"

html_folder_path="/var/www/html/"
webshared_root_folder_name="cloud"
apache_webshared_root_folder="${html_folder_path}/${webshared_root_folder_name}"
html_shared_folder_private="${apache_webshared_root_folder}/private_cloud"
html_shared_folder_public="${apache_webshared_root_folder}/public_cloud"
h5ai_folder_name="_h5ai"

function download_and_prepare_h5ai() {
    pushd "$MYDIR_"

    if [ ! -d "$h5ai_folder_name" ]
    then
        echo -e "[ h5ai ] download"
        wget https://release.larsjung.de/h5ai/h5ai-0.29.0.zip
        echo -e "[ h5ai ]  unzip"
        unzip h5ai-0.29.0.zip

        #_h5ai/private/php/core/class-json.php
    else
        echo -e "[ h5ai ] already downloaded"
    fi

    popd
}

function copy_h5ai_to() {
    local to="$1"
    if [ ! -d "${to}/${h5ai_folder_name}" ]
    then
        echo -e "[ h5ai ] copy ${MYDIR_}/${h5ai_folder_name} to ${to}/${h5ai_folder_name} "
        sudo cp -r "${MYDIR_}/${h5ai_folder_name}" "${to}/${h5ai_folder_name}"
    else
        echo -e "[ h5ai ] ${to}/${h5ai_folder_name} already exists."
    fi
}

function generate_htaccess() {
    local h5ai_path="$1"
    local htaccess_content="DirectoryIndex  index.html  index.php /${h5ai_path}/_h5ai/public/index.php"
    local full_htaccess_path="${html_folder_path}/${h5ai_path}/.htaccess"
    grep -i "${htaccess_content}" "$full_htaccess_path"
    if [ "$?" -ne 0 ]
    then
        echo -e "[ h5ai ] add $htaccess_content to .htaccess"
        sudo bash -c "echo -e ${htaccess_content} >> ${full_htaccess_path}"
    else
        echo -e "[ h5ai ] $htaccess_content already added."
    fi
}

download_and_prepare_h5ai
copy_h5ai_to "$html_shared_folder_private"
copy_h5ai_to "$html_shared_folder_public"
generate_htaccess "${webshared_root_folder_name}/private_cloud/"
generate_htaccess "${webshared_root_folder_name}/public_cloud/"
