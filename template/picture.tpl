{extends file="__layout.tpl"}

{block name="head_assets" append}
    <!-- head_assets (PICTURE) -->
    {if $TAGS_PERMISSION_DELETE || $TAGS_PERMISSION_ADD}
	<link rel="stylesheet" type="text/css" href="{$ROOT_URL}themes/simple-responsive/css/selectize-bootstrap.css">
    {/if}
    {if $theme_config->slick_enabled && sizeOf($thumbnails) > 1}
	<link rel="stylesheet" type="text/css" href="{$ROOT_URL}themes/simple-responsive/css/slick.css">
    {/if}
    {if $theme_config->photoswipe}
	<link rel="stylesheet" type="text/css" href="{$ROOT_URL}themes/simple-responsive/css/photoswipe.css">
    {/if}
    <!-- /head_assets (PICTURE)-->
{/block}

{block name="footer_assets"}
    {$smarty.block.parent}
    <!-- footer_assets (PICTURE) -->
    <script src="{$ROOT_URL}themes/simple-responsive/js/jquery.mobile-events.min.js"></script>
    <script>
     $('#theImage img').bind('swipeleft swiperight', function (event) {
	 if (event.type == 'swipeleft') {
	     $('#navigationButtons a#navNextPicture i').click();
	 } else if (event.type == 'swiperight') {
	     $('#navigationButtons a#navPrevPicture i').click();
	 } else {
	     return;
	 }
     });
    </script>
    <script src="{$ROOT_URL}themes/legacy/js/plugins/jquery.ajaxmanager.js"></script>
    <script src="{$ROOT_URL}themes/legacy/js/thumbnails.loader.js"></script>
    {if $TAGS_PERMISSION_DELETE || $TAGS_PERMISSION_ADD}
	<script src="{$ROOT_URL}themes/simple-responsive/js/selectize.min.js"></script>
	<script src="{$ROOT_URL}themes/simple-responsive/js/picture_tags.js"></script>
	<script>
	 var user_tags = user_tags || {};
	 user_tags.allow_delete = {$TAGS_PERMISSION_DELETE};
	 user_tags.allow_creation = {$TAGS_PERMISSION_ALLOW_CREATION};
	 user_tags.ws_getList = "{$USER_TAGS_WS_GETLIST}";
	 user_tags.tags_updated = "{"Tags updated"|translate}";
	</script>
    {/if}
    <!-- footer_assets (PICTURE) -->

    <!-- footer_assets (INFO_CARDS) -->
    <script>
     var phyxo_rating_1 = "{'%d rate'|translate|@escape:'javascript'}";
     var phyxo_ratings = "{'%d rates'|translate|@escape:'javascript'}";
     var phyxo_root_url = "{$ROOT_URL}";
     var phyxo_image_id = {$current.id};
    </script>
    <script src="{$ROOT_URL}themes/legacy/js/scripts.js"></script>
    <script src="{$ROOT_URL}themes/simple-responsive/js/rating.js"></script>
    <script>
     function setPrivacyLevel(id, level, label) {
	 (new PwgWS('{$ROOT_URL}')).callService(
	     "pwg.images.setPrivacyLevel", { image_id:id, level:level},
	     {
		 method: "POST",
		 onFailure: function(num, text) { alert(num + " " + text); },
		 onSuccess: function(result) {
		     jQuery('#dropdownPermissions').html(label);
		     jQuery('.permission-li').removeClass('active');
		     jQuery('#permission-' + level).addClass('active');
		 }
	     }
	 );
     }

     $('#show_exif_data').on('click', function() {
	 if ($('#full_exif_data').hasClass('d-none')) {
	     $('#full_exif_data').addClass('d-flex').removeClass('d-none');
	     $('#show_exif_data').html('<i class="fas fa-info mr-1"></i> {"Hide EXIF data"|translate}');
	 } else {
	     $('#full_exif_data').addClass('d-none').removeClass('d-flex');
	     $('#show_exif_data').html('<i class="fas fa-info mr-1"></i> {"Show EXIF data"|translate}');
	 }
     });
    </script>

    {if $theme_config->slick_enabled && sizeOf($thumbnails) > 1}
	{include file="_slick_js.tpl"}
    {/if}

    {if $theme_config->photoswipe && !$theme_config->slick_infinite}
	{include file="_photoswipe_js.tpl" selector="#thumbnailCarousel"}
    {/if}
    {if $theme_config->photoswipe && $theme_config->slick_infinite}
	{include file="_photoswipe_js.tpl" selector="#photoSwipeData"}
    {/if}
    <!-- /footer_assets (INFO_CARDS) -->
{/block}

{block name="content"}
    {if !empty($PLUGIN_PICTURE_BEFORE)}{$PLUGIN_PICTURE_BEFORE}{/if}

    {$PICTURE_NAV}

    <div id="main-picture-container" class="container{if $theme_config->fluid_width}-fluid{/if}">
	{include file='infos_errors.tpl'}

	<div class="row justify-content-center">
	    {include file='picture_nav_buttons.tpl'}
	</div>

	<div id="theImage" class="row d-block justify-content-center mb-3">
	    {$ELEMENT_CONTENT}
	</div>

	{if $theme_config->picture_info == 'sidebar'}
	    {include file='picture_info_sidebar.tpl'}
	{/if}

	<div id="theImageComment" class="row justify-content-center mb-3">
	    {if isset($COMMENT_IMG)}
		<div class="text-center col-lg-10 -col-md-12 mx-auto">
		    <section id="important-info">
			<h5 class="imageComment">{$COMMENT_IMG}</h5>
		    </section>
		</div>
	    {/if}
	</div>

	{include file="http_scheme.tpl"}
	{if $theme_config->social_enabled}
	    <div id="theImageShareButtons" class="row justify-content-center{if !$theme_config->slick_enabled} pb-4{/if}">
		<section id="share">
		    {if $theme_config->social_twitter}
			<a href="http://twitter.com/share?text={$current.TITLE}&amp;url={$http_scheme}://{$smarty.server.HTTP_HOST}{$smarty.server.REQUEST_URI}"
			   onclick="window.open(this.href, 'twitter-share', 'width=550,height=235');return false;" title="Share on Twitter"{if $theme_config->social_buttons} class="btn btn-sm btn-social btn-raised btn-twitter"{/if}>
			    <i class="fab fa-twitter"></i>{if $theme_config->social_buttons} Twitter{/if}
			</a>
		    {/if}
		    {if $theme_config->social_facebook}
			<a href="https://www.facebook.com/sharer/sharer.php?u={$http_scheme}://{$smarty.server.HTTP_HOST}{$smarty.server.REQUEST_URI}"
			   onclick="window.open(this.href, 'facebook-share','width=580,height=296');return false;" title="Share on Facebook"{if $theme_config->social_buttons} class="btn btn-sm btn-social btn-raised btn-facebook"{/if}>
			    <i class="fab fa-facebook"></i>{if $theme_config->social_buttons} Facebook{/if}
			</a>
		    {/if}
		    {if $theme_config->social_google_plus}
			<a href="https://plus.google.com/share?url={$http_scheme}://{$smarty.server.HTTP_HOST}{$smarty.server.REQUEST_URI}"
			   onclick="window.open(this.href, 'google-plus-share', 'width=490,height=530');return false;" title="Share on Google+"{if $theme_config->social_buttons} class="btn btn-sm btn-social btn-raised btn-google"{/if}>
			    <i class="fab fa-google"></i>{if $theme_config->social_buttons} Google+{/if}
			</a>
		    {/if}
		    {if $theme_config->social_pinterest}
			<a href="https://www.pinterest.com/pin/create/button/?url={$http_scheme}://{$smarty.server.HTTP_HOST}{$smarty.server.REQUEST_URI}&media={$http_scheme}://{$smarty.server.HTTP_HOST}{$smarty.server.REQUEST_URI}/../{$current.selected_derivative->get_url()}"
			   onclick="window.open(this.href, 'pinterest-share', 'width=490,height=530');return false;" title="Pin on Pinterest"{if $theme_config->social_buttons} class="btn btn-sm btn-social btn-raised btn-pinterest"{/if}>
			    <i class="fab fa-pinterest"></i>{if $theme_config->social_buttons} Pinterest{/if}
			</a>
		    {/if}
		    {if $theme_config->social_vk}
			<a href="https://vkontakte.ru/share.php?url={$http_scheme}://{$smarty.server.HTTP_HOST}{$smarty.server.REQUEST_URI}&image={$http_scheme}://{$smarty.server.HTTP_HOST}{$smarty.server.REQUEST_URI}/../{$current.selected_derivative->get_url()}"
			   onclick="window.open(this.href, 'vk-share', 'width=490,height=530');return false;" title="Share on VK"{if $theme_config->social_buttons} class="btn btn-sm btn-social btn-raised btn-vk"{/if}>
			    <i class="fab fa-vk"></i>{if $theme_config->social_buttons} VK{/if}
			</a>
		    {/if}
		</section>
	    </div>
	{/if}
    </div>

    <div id="carousel-container" class="container">
	{if !empty($thumbnails) && ($theme_config->slick_enabled || $theme_config->photoswipe)}
	    <div id="theImageCarousel" class="row mx-0{if !$theme_config->slick_enabled} d-none{/if}">
		<div class="col-lg-10 col-md-12 mx-auto">
		    <div id="thumbnailCarousel" class="slick-carousel{if $theme_config->slick_centered} center{/if}">
			{foreach $thumbnails as $thumbnail}
			    {assign var=derivative value=$pwg->derivative($derivative_params_square, $thumbnail.src_image)}
			    {if !$theme_config->slick_infinite}
				{assign var=derivative_medium value=$pwg->derivative($derivative_params_medium, $thumbnail.src_image)}
				{assign var=derivative_large value=$pwg->derivative($derivative_params_large, $thumbnail.src_image)}
				{assign var=derivative_xxlarge value=$pwg->derivative($derivative_params_xxlarge, $thumbnail.src_image)}
			    {/if}

			    {if $theme_config->photoswipe && !$theme_config->slick_infinite}
				<div class="text-center{if $thumbnail.id eq $current.id && !$theme_config->slick_infinite} thumbnail-active{/if}">
				    <a{if $thumbnail.id eq $current.id} id="thumbnail-active"{/if} href="{$thumbnail.URL}" data-index="{$thumbnail@index}" data-name="{$thumbnail.NAME}" data-description="{$thumbnail.DESCRIPTION}" {if !$theme_config->slick_infinite}data-src-xlarge="{$derivative_xxlarge->get_url()}" data-size-xlarge="{$derivative_xxlarge->get_size_hr()}" data-src-large="{$derivative_large->get_url()}" data-size-large="{$derivative_large->get_size_hr()}" data-src-medium="{$derivative_medium->get_url()}" data-size-medium="{$derivative_medium->get_size_hr()}" {if preg_match("/(mp4|m4v)$/", $thumbnail.PATH)} data-src-original="{$U_HOME}{$thumbnail.PATH}" data-size-original="{$thumbnail.SIZE}" data-video="true"{else}{if $theme_config->photoswipe_metadata} data-exif-make="{$thumbnail.EXIF.make}" data-exif-model="{$thumbnail.EXIF.model}" data-exif-lens="{$thumbnail.EXIF.lens}" data-exif-iso="{$thumbnail.EXIF.iso}" data-exif-apperture="{$thumbnail.EXIF.apperture}" data-exif-shutter-speed="{$thumbnail.EXIF.shutter_speed}" data-exif-focal-length="{$thumbnail.EXIF.focal_length}" data-date-created="{$thumbnail.DATE_CREATED}"{/if}{/if}{/if}>
					<img {if $derivative->is_cached()}data-lazy="{$derivative->get_url()}"{else}data-lazy="{$ROOT_URL}{$themeconf.icon_dir}/img_small.png" data-src="{$derivative->get_url()}"{/if} alt="{$thumbnail.TN_ALT}" title="{$thumbnail.TN_TITLE}" class="img-fluid">
				    </a>
				</div>
			    {else}
				<div class="text-center{if $thumbnail.id eq $current.id} thumbnail-active{/if}">
				    <a href="{$thumbnail.URL}">
					<img {if $derivative->is_cached()}data-lazy="{$derivative->get_url()}"{else}data-lazy="{$ROOT_URL}{$themeconf.icon_dir}/img_small.png" data-src="{$derivative->get_url()}"{/if} alt="{$thumbnail.TN_ALT}" title="{$thumbnail.TN_TITLE}" class="img-fluid">
				    </a>
				</div>
			    {/if}
			{/foreach}
		    </div>
		</div>
	    </div>

	    {if $theme_config->photoswipe && $theme_config->slick_infinite}
		<div id="photoSwipeData" class="d-none">
		    {foreach $thumbnails as $thumbnail}
			{assign var=derivative_medium value=$pwg->derivative($derivative_params_medium, $thumbnail.src_image)}
			{assign var=derivative_large value=$pwg->derivative($derivative_params_large, $thumbnail.src_image)}
			{assign var=derivative_xxlarge value=$pwg->derivative($derivative_params_xxlarge, $thumbnail.src_image)}
			<a{if $thumbnail.id eq $current.id} id="thumbnail-active"{/if} href="{$thumbnail.URL}" data-index="{$thumbnail@index}" data-name="{$thumbnail.NAME}" data-description="{$thumbnail.DESCRIPTION}" data-src-xlarge="{$derivative_xxlarge->get_url()}" data-size-xlarge="{$derivative_xxlarge->get_size_hr()}" data-src-large="{$derivative_large->get_url()}" data-size-large="{$derivative_large->get_size_hr()}" data-src-medium="{$derivative_medium->get_url()}" data-size-medium="{$derivative_medium->get_size_hr()}"{if preg_match("/(mp4|m4v)$/", $thumbnail.PATH)} data-src-original="{$U_HOME}{$thumbnail.PATH}" data-size-original="{$thumbnail.SIZE}" data-video="true"{else}{if $theme_config->photoswipe_metadata} data-exif-make="{$thumbnail.EXIF.make}" data-exif-model="{$thumbnail.EXIF.model}" data-exif-lens="{$thumbnail.EXIF.lens}" data-exif-iso="{$thumbnail.EXIF.iso}" data-exif-apperture="{$thumbnail.EXIF.apperture}" data-exif-shutter-speed="{$thumbnail.EXIF.shutter_speed}" data-exif-focal-length="{$thumbnail.EXIF.focal_length}" data-date-created="{$thumbnail.DATE_CREATED}"{/if}{/if}></a>
		    {/foreach}
		</div>
	    {/if}
	{/if}
    </div>

    <div id="info-container" class="container{if $theme_config->fluid_width}-fluid{/if}">
	<div id="theImageInfos" class="row justify-content-center">
	    {if $theme_config->picture_info == 'cards'}
		{include file='picture_info_cards.tpl'}
	    {elseif $theme_config->picture_info == 'tabs'}
		{include file='picture_info_tabs.tpl'}
	    {elseif $theme_config->picture_info == 'sidebar' || $theme_config->picture_info == 'disabled'}
		<div class="col-lg-8 col-md-10 col-12 mx-auto">
		    {include file='picture_info_comments.tpl'}
		</div>
	    {/if}
	</div>

	{if !empty($PLUGIN_PICTURE_AFTER)}{$PLUGIN_PICTURE_AFTER}{/if}
    </div>

    {if $theme_config->photoswipe}
	{include file='_photoswipe_div.tpl'}
    {/if}
{/block}
