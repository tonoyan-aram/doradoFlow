import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/content_cards.dart';

const _favoriteAccent = Color(0xFFFFE066);

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          final favoriteIdeas = appProvider.favoriteIdeas;
          final favoriteArticles = appProvider.favoriteArticles;
          final bookmarkedArticles = appProvider.bookmarkedArticles;

          if (favoriteIdeas.isEmpty && favoriteArticles.isEmpty && bookmarkedArticles.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.favorite_border_rounded,
                    size: 64,
                    color: Colors.white54,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start adding favorites to see them here',
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            );
          }

          return DefaultTabController(
            length: 3,
            child: Column(
              children: [
                TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  indicatorColor: _favoriteAccent,
                  tabs: const [
                    Tab(text: 'Ideas', icon: Icon(Icons.lightbulb_rounded)),
                    Tab(text: 'Articles', icon: Icon(Icons.article_rounded)),
                    Tab(text: 'Bookmarks', icon: Icon(Icons.bookmark_rounded)),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildIdeasTab(favoriteIdeas, appProvider),
                      _buildArticlesTab(favoriteArticles, appProvider),
                      _buildBookmarksTab(bookmarkedArticles, appProvider),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildIdeasTab(List favoriteIdeas, AppProvider appProvider) {
    if (favoriteIdeas.isEmpty) {
      return _buildEmptyState(Icons.lightbulb_outline_rounded, 'No favorite ideas', 'Mark ideas as favorites to see them here');
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: favoriteIdeas.length,
      itemBuilder: (context, index) {
        return ContentCards.buildIdeaCard(context, favoriteIdeas[index], appProvider);
      },
    );
  }

  Widget _buildArticlesTab(List favoriteArticles, AppProvider appProvider) {
    if (favoriteArticles.isEmpty) {
      return _buildEmptyState(Icons.article_outlined, 'No favorite articles', 'Mark articles as favorites to see them here');
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: favoriteArticles.length,
      itemBuilder: (context, index) {
        final article = favoriteArticles[index];
        return Card(
          color: Theme.of(context).cardColor,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: ListTile(
            leading: Icon(Icons.article_rounded, color: Theme.of(context).colorScheme.primary),
            title: Text(article.title),
            subtitle: article.summary != null ? Text(article.summary!, style: const TextStyle(color: Colors.white70)) : null,
            trailing: IconButton(
              icon: Icon(
                article.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: article.isFavorite ? Colors.red : null,
              ),
              onPressed: () => appProvider.toggleFavorite(article.id),
            ),
            onTap: () {
              appProvider.markAsRead(article.id);
            },
          ),
        );
      },
    );
  }

  Widget _buildBookmarksTab(List bookmarkedArticles, AppProvider appProvider) {
    if (bookmarkedArticles.isEmpty) {
      return _buildEmptyState(Icons.bookmark_border_rounded, 'No bookmarks', 'Bookmark articles to see them here');
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookmarkedArticles.length,
      itemBuilder: (context, index) {
        final article = bookmarkedArticles[index];
        return Card(
          color: Theme.of(context).cardColor,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: ListTile(
            leading: Icon(Icons.bookmark_rounded, color: Theme.of(context).colorScheme.primary),
            title: Text(article.title),
            subtitle: article.summary != null ? Text(article.summary!, style: const TextStyle(color: Colors.white70)) : null,
            trailing: IconButton(
              icon: Icon(
                article.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: article.isBookmarked ? Theme.of(context).colorScheme.primary : null,
              ),
              onPressed: () => appProvider.toggleBookmark(article.id),
            ),
            onTap: () {
              appProvider.markAsRead(article.id);
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(IconData icon, String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.white54),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}


