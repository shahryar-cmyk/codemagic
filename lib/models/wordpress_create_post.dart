class WordPressCreatePost {
  final Title title;
  final Content content;
  final Links links;
  WordPressCreatePost({this.title, this.content, this.links});
  factory WordPressCreatePost.fromJson(Map<String, dynamic> parsedJson) {
    return WordPressCreatePost(
      title: Title.fromjson(parsedJson['title']),
      content: Content.fromJson(parsedJson['content']),
      links: Links.fromJson(parsedJson['_links']),
    );
  }
}

class Title {
  final String rendered;
  Title({this.rendered});
  factory Title.fromjson(Map<String, dynamic> parsedJson) {
    return Title(rendered: parsedJson['rendered']);
  }
}

class Content {
  final String rendered;
  Content({this.rendered});
  factory Content.fromJson(Map<String, dynamic> parsedJson) {
    return Content(rendered: parsedJson['rendered']);
  }
}

class Links {
  final List<Self> self;
  final List<Collection> collection;
  final List<About> about;
  final List<Author> author;
  final List<Replies> replies;
  final List<VersionHistory> versionHistory;
  final List<WpFeaturedMedia> wpFeaturedMedia;
  final List<WpAttachment> wpAttachment;
  final List<WpTerm> wpTerm;
  final List<WpActionPublish> wpActionPublish;
  final List<WpActionAssignCategories> wpActionAssignCategories;
  final List<WpActionCreateTags> wpActionCreateTags;
  final List<WpActionAssignTags> wpActionAssignTags;
  final List<Curies> curies;
  Links(
      {this.self,
      this.collection,
      this.about,
      this.author,
      this.replies,
      this.versionHistory,
      this.wpFeaturedMedia,
      this.wpAttachment,
      this.wpTerm,
      this.wpActionPublish,
      this.wpActionAssignCategories,
      this.wpActionCreateTags,
      this.wpActionAssignTags,
      this.curies});
  factory Links.fromJson(Map<String, dynamic> parsedJson) {
    var listself = parsedJson['self'] as List;
    List<Self> selfList = listself.map((e) => Self.fromJson(e)).toList();
    var listcollection = parsedJson['collection'] as List;
    List<Collection> collectionList =
        listcollection.map((e) => Collection.fromJson(e)).toList();
    var listAbout = parsedJson['about'] as List;
    List<About> aboutList = listAbout.map((e) => About.fromJson(e)).toList();
    var listAuthor = parsedJson['author'] as List;
    List<Author> authorList =
        listAuthor.map((e) => Author.fromJson(e)).toList();
    var listReplies = parsedJson['replies'] as List;
    List<Replies> repliesList =
        listReplies.map((e) => Replies.fromJson(e)).toList();
    var listVersionHistory = parsedJson['version-history'] as List;
    List<VersionHistory> versionHistoryList =
        listVersionHistory.map((e) => VersionHistory.fromJson(e)).toList();
    var listWpFeaturedMedia = parsedJson['wp:featuredmedia'] as List;
    List<WpFeaturedMedia> wpFeaturedMediaList =
        listWpFeaturedMedia.map((e) => WpFeaturedMedia.fromJson(e)).toList();
    var listAttachment = parsedJson['wp:attachment'] as List;
    List<WpAttachment> wpattachmentList =
        listAttachment.map((e) => WpAttachment.fromJson(e)).toList();
    var listWpTerm = parsedJson['wp:term'] as List;
    List<WpTerm> wpTermList =
        listWpTerm.map((e) => WpTerm.fromJson(e)).toList();
    var listwpactionpublish = parsedJson['wp:action-publish'] as List;
    List<WpActionPublish> wpActionPublishList =
        listwpactionpublish.map((e) => WpActionPublish.fromJson(e)).toList();
    var listWpActionAssignCategories =
        parsedJson['wp:action-assign-categories'] as List;
    List<WpActionAssignCategories> wpActionAssignCategoriesList =
        listWpActionAssignCategories
            .map((e) => WpActionAssignCategories.fromJson(e))
            .toList();
    var listWpActionCreateTags = parsedJson['wp:action-create-tags'] as List;
    List<WpActionCreateTags> wpActionCreateTagsList = listWpActionCreateTags
        .map((e) => WpActionCreateTags.fromJson(e))
        .toList();
    var listWpActionAssignTags = parsedJson['wp:action-assign-tags'] as List;
    List<WpActionAssignTags> wpActionAssignTagsList = listWpActionAssignTags
        .map((e) => WpActionAssignTags.fromJson(e))
        .toList();
    var listCuries = parsedJson['curies'] as List;
    List<Curies> curiesList =
        listCuries.map((e) => Curies.fromJson(e)).toList();
    return Links(
        self: selfList,
        collection: collectionList,
        about: aboutList,
        author: authorList,
        replies: repliesList,
        versionHistory: versionHistoryList,
        wpFeaturedMedia: wpFeaturedMediaList,
        wpAttachment: wpattachmentList,
        wpTerm: wpTermList,
        wpActionPublish: wpActionPublishList,
        wpActionAssignCategories: wpActionAssignCategoriesList,
        wpActionCreateTags: wpActionCreateTagsList,
        wpActionAssignTags: wpActionAssignTagsList,
        curies: curiesList);
  }
}

class Self {
  final String href;
  Self({this.href});
  factory Self.fromJson(Map<String, dynamic> parsedJson) {
    return Self(href: parsedJson['href']);
  }
}

class Collection {
  final String href;
  Collection({this.href});
  factory Collection.fromJson(Map<String, dynamic> parsedJson) {
    return Collection(href: parsedJson['href']);
  }
}

class About {
  final String href;
  About({this.href});
  factory About.fromJson(Map<String, dynamic> parsedJson) {
    return About(href: parsedJson['href']);
  }
}

class Author {
  final bool embeddable;
  final String href;
  Author({this.embeddable, this.href});
  factory Author.fromJson(Map<String, dynamic> parsedJson) {
    return Author(
      embeddable: parsedJson['embeddable'],
      href: parsedJson['href'],
    );
  }
}

class Replies {
  final bool embeddable;
  final String href;
  Replies({this.embeddable, this.href});
  factory Replies.fromJson(Map<String, dynamic> parsedJson) {
    return Replies(
      embeddable: parsedJson['embeddable'],
      href: parsedJson['href'],
    );
  }
}

class VersionHistory {
  final int count;
  final String href;
  VersionHistory({this.count, this.href});
  factory VersionHistory.fromJson(Map<String, dynamic> parsedJson) {
    return VersionHistory(
      count: parsedJson['count'],
      href: parsedJson['href'],
    );
  }
}

class WpFeaturedMedia {
  final bool embeddable;
  final String href;
  WpFeaturedMedia({this.embeddable, this.href});
  factory WpFeaturedMedia.fromJson(Map<String, dynamic> parsedJson) {
    return WpFeaturedMedia(
      embeddable: parsedJson['embeddable'],
      href: parsedJson['href'],
    );
  }
}

class WpAttachment {
  final String href;
  WpAttachment({this.href});
  factory WpAttachment.fromJson(Map<String, dynamic> parsedJson) {
    return WpAttachment(href: parsedJson['href']);
  }
}

class WpTerm {
  final String taxonomy;
  final bool embeddable;
  final String href;
  WpTerm({this.taxonomy, this.embeddable, this.href});
  factory WpTerm.fromJson(Map<String, dynamic> parsedJson) {
    return WpTerm(
      taxonomy: parsedJson['taxonomy'],
      embeddable: parsedJson['embeddable'],
      href: parsedJson['href'],
    );
  }
}

class WpActionPublish {
  final String href;
  WpActionPublish({this.href});
  factory WpActionPublish.fromJson(Map<String, dynamic> parsedJson) {
    return WpActionPublish(href: parsedJson['href']);
  }
}

class WpActionAssignCategories {
  final String href;
  WpActionAssignCategories({this.href});
  factory WpActionAssignCategories.fromJson(Map<String, dynamic> parsedJson) {
    return WpActionAssignCategories(href: parsedJson['href']);
  }
}

class WpActionCreateTags {
  final String href;
  WpActionCreateTags({this.href});
  factory WpActionCreateTags.fromJson(Map<String, dynamic> parsedJson) {
    return WpActionCreateTags(href: parsedJson['href']);
  }
}

class WpActionAssignTags {
  final String href;
  WpActionAssignTags({this.href});
  factory WpActionAssignTags.fromJson(Map<String, dynamic> parsedJson) {
    return WpActionAssignTags(href: parsedJson['href']);
  }
}

class Curies {
  final String name;
  final String href;
  final bool templated;
  Curies({this.name, this.href, this.templated});
  factory Curies.fromJson(Map<String, dynamic> parsedJson) {
    return Curies(
        href: parsedJson['href'],
        name: parsedJson['name'],
        templated: parsedJson['templated']);
  }
}
