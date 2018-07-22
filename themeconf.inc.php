<?php
/*
 * This file is part of Simple Responsive package
 *
 * Copyright(c) Nicolas Roudaire  https://www.phyxo.net/
 * Licensed under the APACHE 2.0 license.
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

 /*
Theme Name: Simple Responsive
Version: 0.3.0
Description: Responsive theme
Theme URI: https://ext.phyxo.net/extension_view.php?eid=5
Author: Nicolas Roudaire
Author URI: https://www.phyxo.net

The theme is based on the original one for piwigo.
 */

require_once(__DIR__ . '/include/themecontroller.php');
require_once(__DIR__ . '/include/config.php');

$themeconf = [
    'name' => 'simple-responsive',
    'parent' => 'legacy',
    'icon_dir' => 'themes/legacy/images',
    'load_parent_css' => false,
    'load_parent_local_head' => true,
    'local_head' => 'local_head.tpl',
    'url' => 'https://www.phyxo.net/'
];

// always show metadata initially
$_SESSION['show_metadata'] = true;

// register video files
$video_ext = ['mp4', 'm4v'];
$conf['file_ext'] = array_merge($conf['file_ext'], $video_ext, array_map('strtoupper', $video_ext));

$controller = new \BootstrapDarkroom\ThemeController();
$controller->init();
