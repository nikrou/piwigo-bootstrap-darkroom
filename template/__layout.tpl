<!DOCTYPE html>
<html lang="{$lang_info.code}" dir="{$lang_info.direction}">
    <head>
	<meta charset="{$CONTENT_ENCODING}">
	<meta name="generator" content="Phyxo, see https://www.phyxo.net/">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta name="mobile-web-app-capable" content="yes">
	<meta name="apple-mobile-web-app-capable" content="yes">
	<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	{if $meta_ref_enabled}
	    {if isset($INFO_AUTHOR)}
		<meta name="author" content="{$INFO_AUTHOR|@strip_tags:false|@replace:'"':' '}">
	    {/if}
	    {if isset($related_tags)}
		<meta name="keywords" content="{foreach from=$related_tags item=tag name=tag_loop}{if !$smarty.foreach.tag_loop.first}, {/if}{$tag.name}{/foreach}">
	    {/if}
	    {if isset($COMMENT_IMG)}
		<meta name="description" content="{$COMMENT_IMG|@strip_tags:false|@replace:'"':' '}{if isset($INFO_FILE)} - {$INFO_FILE}{/if}">
	    {else}
		<meta name="description" content="{$PAGE_TITLE}{if isset($INFO_FILE)} - {$INFO_FILE}{/if}">
	    {/if}
	{/if}

	<title>{if $PAGE_TITLE!=\Phyxo\Functions\Language::l10n('Home') && $PAGE_TITLE!=$GALLERY_TITLE}{$PAGE_TITLE} | {/if}{$GALLERY_TITLE}</title>
	<link rel="icon" sizes="192x192" href="{$ROOT_URL}themes/simple-responsive/img/logo.png">
	<link rel="apple-touch-icon" sizes="192x192" href="{$ROOT_URL}themes/simple-responsive/img/logo.png">
	<link rel="start" title="{'Home'|translate}" href="{$U_HOME}" >
	<link rel="search" title="{'Search'|translate}" href="{$ROOT_URL}search.php">
	{if isset($first.U_IMG)}
	    <link rel="first" title="{'First'|translate}" href="{$first.U_IMG}">
	{/if}
	{if isset($previous.U_IMG)}
	    <link rel="prev" title="{'Previous'|translate}" href="{$previous.U_IMG}">
	{/if}
	{if isset($next.U_IMG)}
	    <link rel="next" title="{'Next'|translate}" href="{$next.U_IMG}">
	{/if}
	{if isset($last.U_IMG)}
	    <link rel="last" title="{'Last'|translate}" href="{$last.U_IMG}">
	{/if}
	{if isset($U_UP)}
	    <link rel="up" title="{'Thumbnails'|translate}" href="{$U_UP}">
	{/if}
	{if isset($U_PREFETCH)}
	    <link rel="prefetch" href="{$U_PREFETCH}">
	{/if}
	{if isset($U_CANONICAL)}
	    <link rel="canonical" href="{$U_CANONICAL}">
	{/if}

	{if $theme_config->bootstrap_theme} {* see https://github.com/tkuther/piwigo-bootstrap-darkroom/issues/104 *}
	    <link rel="stylesheet" type="text/css" href="{$ROOT_URL}themes/simple-responsive/css/{$theme_config->bootstrap_theme}.css">
	{else}
	    <link rel="stylesheet" type="text/css" href="{$ROOT_URL}themes/simple-responsive/css/bootstrap-default.css">
	{/if}
	{if $theme_config->bootstrap_theme == 'bootstrap-darkroom' || $theme_config->bootstrap_theme == 'material-darkroom'}
	    <link rel="stylesheet" type="text/css" href="{$ROOT_URL}themes/simple-responsive/css/typeface.css">
	{elseif (0 === strpos($theme_config->bootstrap_theme, 'material')) || $theme_config->bootstrap_theme == 'bootstrap-default'}
	    <link rel="stylesheet" type="text/css" href="{$ROOT_URL}themes/simple-responsive/css/typeface.css">
	{/if}
	<link rel="stylesheet" type="text/css" href="{$ROOT_URL}themes/simple-responsive/css/bootstrap-social.css">
	{foreach $themes as $theme}
	    {if $theme.load_css}
		<link rel="stylesheet" type="text/css" href="{$ROOT_URL}themes/{$theme.id}/css/theme.css">
	    {/if}
	    {if !empty($theme.local_head)}{include file=$theme.local_head load_css=$theme.load_css}{/if}
	{/foreach}
	{if file_exists("local/simple-responsive/custom.css")}
	    <link rel="stylesheet" type="text/css" href="{$ROOT_URL}local/simple-responsive/custom.css">
	{/if}

	{block name="head_assets"}
	    <!-- head_assets (LAYOUT) -->
	    <script src="{$ROOT_URL}themes/simple-responsive/js/jquery.min.js"></script>
	    <script src="{$ROOT_URL}themes/simple-responsive/js/jquery-migrate.min.js"></script>
	    <script src="{$ROOT_URL}themes/legacy/js/plugins/jquery.ajaxmanager.js"></script>
	    <script src="{$ROOT_URL}themes/legacy/js/thumbnails.loader.js"></script>
	    <script src="{$ROOT_URL}themes/simple-responsive/js/popper.min.js"></script>
	    {if preg_match('/^material/', $theme_config->bootstrap_theme)}
		<script src="{$ROOT_URL}themes/simple-responsive/js/bootstrap-material-design.min.js"></script>
	    {else}
		<script src="{$ROOT_URL}themes/simple-responsive/js/bootstrap.min.js"></script>
	    {/if}
	    <script src="{$ROOT_URL}themes/simple-responsive/js/theme.js"></script>
	    {if not empty($head_elements)}
		{foreach $head_elements as $elt}
		    {$elt}
		{/foreach}
	    {/if}
	    <!-- /head_assets (LAYOUT) -->
	{/block}
    </head>
    <body>
	<div id="wrapper">
	    {if isset($MENUBAR)}
		<nav class="navbar navbar-expand-lg navbar-main {$theme_config->navbar_main_bg} {if $theme_config->page_header == 'fancy'}navbar-dark navbar-transparent fixed-top{else}{$theme_config->navbar_main_style}{/if}">
		    <div class="container{if $theme_config->fluid_width}-fluid{/if}">
			{if $theme_config->logo_image_enabled && $theme_config->logo_image_path !== ''}
			    <a class="navbar-brand mr-auto" href="{$U_HOME}"><img class="img-fluid" src="{$ROOT_URL}{$theme_config->logo_image_path}" alt="{$GALLERY_TITLE}"/></a>
			{else}
			    <a class="navbar-brand mr-auto" href="{$U_HOME}">{$GALLERY_TITLE}</a>
			{/if}
			<button type="button" class="navbar-toggler" data-toggle="collapse" data-target="#navbar-menubar" aria-controls="navbar-menubar" aria-expanded="false" aria-label="Toggle navigation">
			    <span class="fas fa-bars"></span>
			</button>
			<div class="collapse navbar-collapse" id="navbar-menubar">
			    {if $theme_config->quicksearch_navbar}
				<form class="form-inline navbar-form ml-auto" role="search" action="{$ROOT_URL}qsearch.php" method="get" id="quicksearch" onsubmit="return this.q.value!='' && this.q.value!=qsearch_prompt;">
				    <i class="fas fa-search" title="{'Search'|translate}" aria-hidden="true"></i>
				    <div class="form-group">
					<input type="text" name="q" id="qsearchInput" class="form-control" placeholder="{'Search'|translate}" />
				    </div>
				</form>
			    {/if}
			    {block name="menubar"}
				{include file="menubar.tpl"}
			    {/block}
			</div>
		    </div>
		</nav>
	    {/if}

	    {if !isset($slideshow) && !empty($MENUBAR)}
		{if $theme_config->page_header == 'jumbotron'}
		    <div class="jumbotron mb-0">
			<div class="container{if $theme_config->fluid_width}-fluid{/if}">
			    <div id="theHeader">{$PAGE_BANNER}</div>
			</div>
		    </div>
		{elseif $theme_config->page_header == 'fancy'}
		    <div class="page-header{if !$theme_config->page_header_full || ($theme_config->page_header_full && !$is_homepage)} page-header-small{/if}">
			<div class="page-header-image" style="background-image: url({$theme_config->page_header_image}); transform: translate3d(0px, 0px, 0px);"></div>
			<div class="container">
			    <div id="theHeader" class="content-center">
				{$PAGE_BANNER}
			    </div>
			</div>
		    </div>
		{/if}
	    {/if}

	    {if not empty($header_msgs)}
		{foreach $header_msgs as $msg}
		{/foreach}
	    {/if}

	    {if not empty($header_notes)}
		{foreach $header_notes as $note}
		{/foreach}
	    {/if}

	    {block name="content"}{/block}

	    {if !empty($cats_navbar)}
		{include file='navigation_bar.tpl' navbar=$cats_navbar}
	    {/if}

	    {if !empty($thumb_navbar)}
		{include file='navigation_bar.tpl' navbar=$thumb_navbar}
	    {/if}

	    <div class="copyright container{if $theme_config->fluid_width}-fluid{/if}">
		<div class="text-center">
		    {if isset($debug.TIME)}
			{'Page generated in'|translate} {$debug.TIME} ({$debug.NB_QUERIES} {'SQL queries in'|translate} {$debug.SQL_TIME}) -
		    {/if}
		    {'Powered by'|translate}	<a href="{$PHPWG_URL}">Phyxo</a>
		    {$VERSION}
		    {if isset($CONTACT_MAIL)}
			| <a href="mailto:{$CONTACT_MAIL}?subject={'A comment on your site'|translate|@escape:url}">{'Contact webmaster'|translate}</a>
		    {/if}
		    {if isset($TOGGLE_MOBILE_THEME_URL)}
			| {'View in'|translate} : <a href="{$TOGGLE_MOBILE_THEME_URL}">{'Mobile'|translate}</a> | <b>{'Desktop'|translate}</b>
		    {/if}

		    {if isset($footer_elements)}
			{foreach $footer_elements as $v}
			    {$v}
			{/foreach}
		    {/if}
		</div>
	    </div>
	</div>

	{block name="footer_assets"}
	    <!-- footer_assets (LAYOUT) -->
	    <script>
	     $('#categoriesDropdownMenu').on('show.bs.dropdown', function() {
		 $(this).find('a.dropdown-item').each(function() {
		     var level = $(this).data('level');
		     var padding = parseInt($(this).css('padding-left'));
		     if (level > 0) {
			 $(this).css('padding-left', (padding + 10 * level) + 'px')
		     }
		 });
	     });
	    </script>
	    {include file='_plugin_fixes_js.tpl'}
	    <script>
	     var qsearch_icon = $('#navbar-menubar>#quicksearch>.fa-search');
	     var qsearch_text = $('#navbar-menubar>#quicksearch #qsearchInput');
	     $(qsearch_icon).click(function () {
		 $(qsearch_text).focus();
	     });
	     $(function() {
		 $('#navbar-menubar>#quicksearch').css({literal}{'color': $('#navbar-menubar .nav-link').css('color')}{/literal});
	     });

	     $('.navbar-main .navbar-collapse').on('show.bs.collapse', function() {
		 $('.navbar-main').attr('style', 'background-color: rgba(0, 0, 0, 0.9) !important');
	     });
	     $('.navbar-main .navbar-collapse').on('hidden.bs.collapse', function() {
		 $('.navbar-main').attr('style', '');
	     });

	     {* move to main navbar to avoid scrolling issues in navmenu on mobile devices *}
	     $(function() {
		 $('#languageSwitch').appendTo('#navbar-menubar>ul.navbar-nav');
	     });
	    </script>
	    <!-- /footer_assets (LAYOUT) -->
        {/block}
    </body>
</html>
