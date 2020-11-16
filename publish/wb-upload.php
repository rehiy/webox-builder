<?php

if (isset($_FILES['gXMz8STP4RGwtK1QJ'])) {
    put_webox($_FILES['gXMz8STP4RGwtK1QJ']);
}

output('unkown_error');

//////////////////////////////////////////////////////////////////////

function output($txt)
{
    exit($txt . "\n");
}

function put_webox($upfe)
{
    if (!preg_match('/-v[\-\d]+/', $upfe['name'])) {
        output('tarball_name_error');
    }

    $save = get_webox_file('webox/' . $upfe['name']);
    if (move_uploaded_file($upfe['tmp_name'], $save)) {
        output('save as ' . $save);
    }

    output('move_uploaded_error');
}

function get_webox_file($path)
{
    if (!is_file($path)) {
        return $path;
    }

    $search = preg_replace('/\.tgz/', '*', $path);

    return preg_replace_callback(
        '/-v(\d+)(_(\d+))?/',
        function ($ms) {
            if (count($ms) === 2) {
                return '-v' . $ms[1] . '_1';
            }
            if (count($ms) === 4) {
                return '-v' . $ms[1] . '_' . ($ms[3] + 1);
            }
        },
        end(glob($search))
    );
}
