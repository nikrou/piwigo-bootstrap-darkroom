{include file="header.tpl"}

{block name="content"}{/block}

{if !empty($cats_navbar)}
    {include file='navigation_bar.tpl' navbar=$cats_navbar}
{/if}

{if !empty($thumb_navbar)}
    {include file='navigation_bar.tpl' navbar=$thumb_navbar}
{/if}

{include file="footer.tpl"}
