---
layout: article
title: Hegel Röst
tags: [audio, gear, review]
---

<style> 
.swiper-demo { height: 500px; }
img { max-height: 100% }
</style>

<div class="swiper swiper-demo swiper-demo--0">
  <div class="swiper__wrapper">
    <div class="swiper__slide"><img class="lightbox-ignore" src="/assets/images/hegel/rost_front.jpeg"/></div>
    <div class="swiper__slide"><img class="lightbox-ignore" src="/assets/images/hegel/rost_side.jpeg"/></div>
    <div class="swiper__slide"><img class="lightbox-ignore" src="/assets/images/hegel/rost_back.jpeg"/></div>
  </div>
  <div class="swiper__button swiper__button--prev fas fa-chevron-left"></div>
  <div class="swiper__button swiper__button--next fas fa-chevron-right"></div>
</div>

<script>
  {%- include scripts/lib/swiper.js -%}
  var SOURCES = window.TEXT_VARIABLES.sources;
  window.Lazyload.js(SOURCES.jquery, function() {
    $('.swiper-demo--0').swiper();
  });
</script>