define ['cookieController','template_polyfill','l20n'], (cookieController)->

  class CVController
    constructor: ->
      @pointer_event = 'click'
      

      @cookie = cookieController
      @loading = document.querySelector "body>.loading"


      if document.body.classList.contains('touch') is true
        @pointer_event = 'touchstart'

      languages = document.querySelectorAll "nav.language a"
      for link in languages
        link.addEventListener @pointer_event, @changeLanguage

      @lang = @cookie.getItem 'lang'
      if @lang is null
        @timer = window.setTimeout @deleteLoadingBlock, 1000
        require ['http://freegeoip.net/json/?callback=document.cv.ip2Country']
      else
        document.l10n.once @readyToLocalize


    ip2Country: (obj)=>
      ru_countrys = ['AZ','BY','KZ','KG','MD','MN','RU','TJ','TM','UA','UZ']
      @lang = 'en'
      if obj.country_code in ru_countrys
        @lang = 'ru'

      @cookie.setItem 'lang', @lang, 'Infinity'
      document.l10n.once @readyToLocalize

    changeLanguage: (event)=>
      event.preventDefault()
      link = event.currentTarget
      @lang = link.getAttribute "lang"
      @cookie.setItem 'lang', @lang, 'Infinity'
      document.l10n.requestLocales @lang


    readyToLocalize: =>
      @cookie.setItem 'lang', @lang, 'Infinity'
      document.l10n.addEventListener 'ready', @afterLocalization
      document.l10n.requestLocales @lang

    afterLocalization: =>
      document.l10n.removeEventListener 'ready', @afterLocalization
      @loading.classList.add "loaded"
      window.clearTimeout @timer
      @timer = window.setTimeout @deleteLoadingBlock, 350

    deleteLoadingBlock: =>
      @loading.parentNode.removeChild @loading


  return CVController