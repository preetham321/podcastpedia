<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix='fn' uri='http://java.sun.com/jsp/jstl/functions' %>


<c:url var="jwplayerURL" value="/static/js/jwplayer/jwplayer.js"/>
<script type='text/javascript' src='${jwplayerURL}'></script>
<script type="text/javascript">jwplayer.key="fr4dDcJMQ2v5OaYJSBDXPnTeK6yHi8+8B7H3bg==";</script>

<!-- first there is the my subscriptions categories sections -->
<div id="my_subscription_categories" class="common_radius bg_color shadowy common_mar_pad" style="margin-bottom: 20px">
  <h2 class="title_before_form"><spring:message code="user.subscriptions.categories.title"/></h2>
  <hr class="before_form_header_line"/>
  <ul id="subscription_categories">
    <c:forEach items="${subscriptionCategories}" var="subscriptionCategory">
      <li>
        <c:url value="/users/subscription-categories/${subscriptionCategory}" var="subscriptionCategoryUrl" />
        <a href="${subscriptionCategoryUrl}" class="btn-share"> ${subscriptionCategory} </a>
      </li>
    </c:forEach>
  </ul>
</div>
<div class="clear"></div>

<!-- second part will display the latest updates -->
<h2 class="title_before_form" style="color:white"><spring:message code="search_form.category"/> &gt; ${subscriptionCategory}</h2>
<div class="results_list">
  <c:forEach items="${subscriptions}" var="podcast" varStatus="loop">
    <div class="bg_color shadowy podcast_wrapper">
      <div class="title-and-pub-date">
        <c:choose>
          <c:when test="${podcast.mediaType == 'Audio'}">
            <div class="icon-audio-episode"></div>
          </c:when>
          <c:otherwise>
            <div class="icon-video-episode"></div>
          </c:otherwise>
        </c:choose>
        <c:choose>
          <c:when test="${podcast.identifier == null}">
            <c:set var="urlPodcast" value="/podcasts/${podcast.podcastId}/${podcast.titleInUrl}"/>
          </c:when>
          <c:otherwise>
            <c:set var="urlPodcast" value="/${podcast.identifier}"/>
          </c:otherwise>
        </c:choose>
        <a class="item_title" href="${urlPodcast}">
          <c:out value="${podcast.title}"/>
        </a>
        <div class="pub_date_media_type">
          <div class="pub_date">
            <fmt:formatDate pattern="yyyy-MM-dd" value="${podcast.publicationDate}" />
          </div>
        </div>
        <div class="clear"></div>
      </div>
      <hr>
      <div class="pod_desc">
        <a class="item_desc" href="${urlPodcast}">
            ${fn:substring(podcast.description,0,350)}
        </a>
      </div>
      <div class="pod_desc_bigger">
        <a class="item_desc" href="${urlPodcast}">
            ${fn:substring(podcast.description,0,750)}
        </a>
      </div>
      <div class="clear"></div>
      <div class="social_and_download_podcast">
        <a href="#${2*loop.index}" class="icon-share-podcast btn-share">Share</a>
        <c:choose>
          <c:when test="${podcast.identifier == null}">
            <c:set var="podcast_link" value="https://www.podcastpedia.org/podcasts/${podcast.podcastId}/${podcast.titleInUrl}"/>
          </c:when>
          <c:otherwise>
            <c:set var="podcast_link" value="https://www.podcastpedia.org/${podcast.identifier}"/>
          </c:otherwise>
        </c:choose>
        <span class="podcast_url">${podcast_link}</span>
        <a href="#${2*loop.index+1}" class="icon-last-episodes  icon-arrow-down btn-share"><spring:message code="user.last_episodes"/></a>
        <a href="#${2*loop.index+1}" class="icon-remove-from-subscription-category btn-share" style="background: #8A2908"><spring:message code="user.remove"/></a>
        <input type="hidden" name="podcastId" value="${podcast.podcastId}"/>
        <input type="hidden" name="subscriptionCategory" value="${podcast.subscriptionCategory}"/>
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
      </div>
      <div class="clear"></div>
      <div class="last_episodes not_shown">
        <h2><spring:message code="user.last_episodes"/></h2>
        <c:forEach items="${podcast.episodes}" var="episode" varStatus="loopEpisodes">
          <div class="bg_color shadowy item_wrapper">
            <div class="title-and-pub-date">
              <c:choose>
                <c:when test="${episode.mediaType == 'Audio'}">
                  <div class="icon-audio-episode"></div>
                </c:when>
                <c:otherwise>
                  <div class="icon-video-episode"></div>
                </c:otherwise>
              </c:choose>
              <c:url var="episodeURL" value="/podcasts/${podcast.podcastId}/${podcast.titleInUrl}/episodes/${episode.episodeId}/${episode.titleInUrl}"/>
              <a href="${episodeURL}" class="item_title">${episode.title}</a>
              <div class="pub_date">
                <fmt:formatDate pattern="yyyy-MM-dd" value="${episode.publicationDate}" />
                <c:choose>
                  <c:when test="${episode.isNew == 1}">
                    <span class="ep_is_new"><spring:message code="new"/></span>
                  </c:when>
                </c:choose>
              </div>
              <div class="clear"></div>
            </div>
            <hr>
            <div class="ep_desc">
              <a href="${episodeURL}" class="item_desc">
                  ${fn:substring(episode.description,0,280)}
              </a>
            </div>
            <div class="ep_desc_bigger">
              <a href="${episodeURL}" class="item_desc">
                  ${fn:substring(episode.description,0,600)}
              </a>
            </div>
            <div class="clear"></div>
            <div class="social_and_download">
              <a href="#${10*loop.index + 2*loopEpisodes.index}" class="icon-play-episode btn-share">Play</a>
              <a href="#${10*loop.index + 2*loopEpisodes.index + 1}" class="icon-share-episode btn-share">Share</a>
              <a class="icon-download-ep btn-share" href="${episode.mediaUrl}" download>
                <spring:message code="global.dwnld.s" text="Download last episode"/>
              </a>
              <span class="item_url">https://www.podcastpedia.org/podcasts/${podcast.podcastId}/${podcast.titleInUrl}/episodes/${episode.episodeId}/${episode.titleInUrl}</span>
              <span class="item_sharing_title">${episode.title}</span>
              <span class="item_media_url">${episode.mediaUrl}</span>
            </div>
          </div>
        </c:forEach>
      </div>
      <div class="clear"></div>
    </div>
  </c:forEach>
</div>

<!-- jquery dialogs -->
<div id="media_player_modal_dialog" title="Media player">
  <div id='mediaspace_modal'>Loading...</div>
</div>

<!-- javascript libraries required -->
<script src="//code.jquery.com/jquery-1.9.1.min.js"></script>
<script src="//code.jquery.com/ui/1.11.3/jquery-ui.min.js"></script>
<script src="<c:url value="/static/js/user/subscriptions.js" />"></script>
<script src="<c:url value="/static/js/common/player_dialog.js" />"></script>


