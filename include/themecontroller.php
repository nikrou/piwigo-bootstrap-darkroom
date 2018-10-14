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

namespace BootstrapDarkroom;

use Phyxo\Image\SrcImage;
use Phyxo\Image\ImageStdParams;
use Phyxo\Functions\Plugin;
use Phyxo\Functions\Language;
use Phyxo\Functions\Utils;
use Phyxo\Functions\Metadata;
use Phyxo\Functions\URL;

class ThemeController
{
    private $config, $core_config;

    public function __construct(\Phyxo\Conf $conf)
    {
        $this->core_config = $conf;
        $this->config = new Config($conf);
    }

    public function init()
    {
        Language::load_language('theme.lang', PHPWG_THEMES_PATH . 'simple-responsive/');

        Plugin::add_event_handler('init', array($this, 'assignConfig'));
        Plugin::add_event_handler('init', array($this, 'setInitValues'));

        if ($this->config->bootstrap_theme === 'darkroom' || $this->config->bootstrap_theme === 'material' || $this->config->bootstrap_theme === 'bootswatch') {
            $this->config->bootstrap_theme = 'bootstrap-darkroom';
            $this->config->save();
            Plugin::add_event_handler('loc_begin_page_header', array($this, 'showUpgradeWarning'));
        }

        Plugin::add_event_handler('loc_begin_page_header', array($this, 'checkIfHomepage'));
        Plugin::add_event_handler('loc_after_page_header', array($this, 'stripBreadcrumbs'));
        Plugin::add_event_handler('format_exif_data', array($this, 'exifReplacements'));
        Plugin::add_event_handler('loc_end_picture', array($this, 'registerPictureTemplates'));
        Plugin::add_event_handler('loc_begin_index_thumbnails', array($this, 'returnPageStart'));

        Plugin::add_event_handler('loc_end_picture', array($this, 'getAllThumbnailsInCategory'));
        // also needed on index.tpl for compatibility with GThumb+/GDThumb
        Plugin::add_event_handler('loc_end_index', array($this, 'getAllThumbnailsInCategory'));
    }

    public function assignConfig()
    {
        global $template;

        if (array_key_exists('bootstrap_darkroom_navbar_main_style', $this->core_config) && !empty($this->core_config['bootstrap_darkroom_navbar_main_style'])) {
            $this->config->navbar_main_style = $this->core_config['bootstrap_darkroom_navbar_main_style'];
        }
        if (array_key_exists('bootstrap_darkroom_navbar_main_bg', $this->core_config) && !empty($this->core_config['bootstrap_darkroom_navbar_main_bg'])) {
            $this->config->navbar_main_bg = $this->core_config['bootstrap_darkroom_navbar_main_bg'];
        }
        if (array_key_exists('bootstrap_darkroom_navbar_contextual_style', $this->core_config) && !empty($this->core_config['bootstrap_darkroom_navbar_contextual_style'])) {
            $this->config->navbar_contextual_style = $this->core_config['bootstrap_darkroom_navbar_contextual_style'];
        }
        if (array_key_exists('bootstrap_darkroom_navbar_contextual_bg', $this->core_config) && !empty($this->core_config['bootstrap_darkroom_navbar_contextual_bg'])) {
            $this->config->navbar_contextual_bg = $this->core_config['bootstrap_darkroom_navbar_contextual_bg'];
        }

        $template->assign('theme_config', $this->config);
    }

    public function showUpgradeWarning()
    {
        global $page;
        $page['errors'][] = Language::l10n('Your selected color style has been reset to "bootstrap-darkroom". You can select a different color style in the admin section.');
    }

    public function hideMenus($menus)
    {
        $menu = &$menus[0];

        $mbMenu = $menu->get_block('mbMenu');
        unset($mbMenu->data['comments']);
    }

    public function returnPageStart()
    {
        global $page, $template;

        $template->assign('START_ID', $page['start']);
    }

    public function checkIfHomepage()
    {
        global $template, $page;

        if (isset($page['is_homepage'])) {
            $template->assign('is_homepage', true);
        } else {
            $template->assign('is_homepage', false);
        }
    }

    public function setInitValues()
    {
        global $template, $pwg_loaded_plugins;

        $template->assign(array(
            'loaded_plugins' => $GLOBALS['pwg_loaded_plugins'],
            'meta_ref_enabled' => $this->core_config['meta_ref']
        ));
        if (array_key_exists('bootstrap_darkroom_core_js_in_header', $this->core_config)) {
            $template->assign('bootstrap_darkroom_core_js_in_header', $this->core_config['bootstrap_darkroom_core_js_in_header']);
        } else {
            $template->assign('bootstrap_darkroom_core_js_in_header', false);
        }

        if (isset($pwg_loaded_plugins['language_switch'])) {
            Plugin::add_event_handler('loc_end_search', 'language_controler_flags', 95);
            Plugin::add_event_handler('loc_end_identification', 'language_controler_flags', 95);
            Plugin::add_event_handler('loc_end_tags', 'language_controler_flags', 95);
            Plugin::add_event_handler('loc_begin_about', 'language_controler_flags', 95);
            Plugin::add_event_handler('loc_end_register', 'language_controler_flags', 95);
            Plugin::add_event_handler('loc_end_password', 'language_controler_flags', 95);
        }

        if (isset($pwg_loaded_plugins['exif_view'])) {
            Language::load_language('lang.exif', PHPWG_PLUGINS_PATH . 'exif_view/');
        }
    }

    public function exifReplacements($exif)
    {
        if (array_key_exists('bootstrap_darkroom_ps_exif_replacements', $this->core_config)) {
            foreach ($this->core_config['bootstrap_darkroom_ps_exif_replacements'] as $tag => $replacement) {
                if (is_array($exif) && array_key_exists($tag, $exif)) {
                    $exif[$tag] = str_replace($replacement[0], $replacement[1], $exif[$tag]);
                }
            }
        }
        return $exif;
    }

    // register additional template files
    public function registerPictureTemplates()
    {
        global $template;

        $template->set_filenames(array('picture_nav' => 'picture_nav.tpl'));
        $template->assign_var_from_handle('PICTURE_NAV', 'picture_nav');
    }

    public function stripBreadcrumbs()
    {
        global $page, $template;

        $l_sep = $template->get_template_vars('LEVEL_SEPARATOR');
        $title = $template->get_template_vars('TITLE');
        $section_title = $template->get_template_vars('SECTION_TITLE');
        if (empty($title)) {
            $title = $section_title;
        }
        if (!empty($title)) {
            $splt = strpos($title, "[");
            if ($splt) {
                $title_links = substr($title, 0, $splt);
                $title = $title_links;
            }

            $title = str_replace('<a href', '<a class="nav-breadcrumb-item" href', $title);
            $title = str_replace($l_sep, '', $title);
            if ($page['section'] == 'recent_cats' or $page['section'] == 'favorites') {
                $title = preg_replace('/<\/a>([a-zA-Z0-9]+)/', '</a><a class="nav-breadcrumb-item" href="' . \Phyxo\Functions\URL::make_index_url(array('section' => $page['section'])) . '">${1}', $title) . '</a>';
            }
            if (empty($section_title)) {
                $template->assign('TITLE', $title);
            } else {
                $template->assign('SECTION_TITLE', $title);
            }
        }
    }

    public function getAllThumbnailsInCategory()
    {
        global $template, $user, $page, $conn;

        if (!$page['items'] || ($page['section'] == 'categories' && !isset($page['category']))) {
            return;
        }

        $selection = array_slice(
            $page['items'],
            $page['start'],
            $page['nb_image_page']
        );

        $selection = Plugin::trigger_change('loc_index_thumbnails_selection', $selection);

        if (count($selection) > 0) {
            $rank_of = array_flip($selection);

            $query = 'SELECT * FROM '.IMAGES_TABLE.' WHERE id '.$conn->in($selection);
            $result = $conn->db_query($query);
            while ($row = $conn->db_fetch_assoc($result)) {
                $row['rank'] = $rank_of[ $row['id'] ];
                $pictures[] = $row;
            }

            usort($pictures, '\Phyxo\Functions\Utils::rank_compare');
            unset($rank_of);
        }

        $tpl_thumbnails_var = array();

        $theme_config = $template->get_template_vars('theme_config');

        if ($theme_config->photoswipe_metadata) {
            if (array_key_exists('bootstrap_darkroom_ps_exif_mapping', $this->core_config)) {
                $exif_mapping = $this->core_config['bootstrap_darkroom_ps_exif_mapping'];
            } else {
                $exif_mapping = array(
                    'date_creation' => 'DateTimeOriginal',
                    'make' => 'Make',
                    'model' => 'Model',
                    'lens' => 'UndefinedTag:0xA434',
                    'shutter_speed' => 'ExposureTime',
                    'iso' => 'ISOSpeedRatings',
                    'apperture' => 'FNumber',
                    'focal_length' => 'FocalLength',
                );
            }
        }

        foreach ($pictures as $row) {
            $url = URL::duplicate_picture_url(
                array(
                    'image_id' => $row['id'],
                    'image_file' => $row['file'],
                ),
                array('start')
            );

            $name = Utils::render_element_name($row);
            $desc = Utils::render_element_description($row, 'main_page_element_description');

            $tpl_var = array_merge($row, array(
                'NAME' => $name,
                'TN_ALT' => htmlspecialchars(strip_tags($name)),
                'URL' => $url,
                'DESCRIPTION' => htmlspecialchars(strip_tags($desc)),
                'src_image' => new SrcImage($row),
                'SIZE' => $row['width'] . 'x' . $row['height'],
                'PATH' => $row['path'],
                'DATE_CREATED' => $row['date_creation'],
            ));

            if ($theme_config->photoswipe_metadata) {
                $tpl_var = array_merge($tpl_var, array(
                    'EXIF' => Metadata::get_exif_data($row['path'], $exif_mapping),
                ));

                //optional replacements
                if (array_key_exists('bootstrap_darkroom_ps_exif_replacements', $this->core_config)) {
                    foreach ($this->core_config['bootstrap_darkroom_ps_exif_replacements'] as $tag => $replacement) {
                        if (array_key_exists($tag, $tpl_var['EXIF'])) {
                            $tpl_var['EXIF'][$tag] = str_replace($replacement[0], $replacement[1], $tpl_var['EXIF'][$tag]);
                        }
                    }
                }
            }

            $tpl_thumbnails_var[] = $tpl_var;
        }

        $template->assign('thumbnails', $tpl_thumbnails_var);

        $template->assign(array(
            'derivative_params_square' => Plugin::trigger_change('get_index_derivative_params', ImageStdParams::get_by_type(IMG_SQUARE)),
            'derivative_params_medium' => Plugin::trigger_change('get_index_derivative_params', ImageStdParams::get_by_type(IMG_MEDIUM)),
            'derivative_params_large' => Plugin::trigger_change('get_index_derivative_params', ImageStdParams::get_by_type(IMG_LARGE)),
            'derivative_params_xxlarge' => Plugin::trigger_change('get_index_derivative_params', ImageStdParams::get_by_type(IMG_XXLARGE)),
        ));

        unset($tpl_thumbnails_var, $pictures);
    }
}
