import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies_app_clean/core/network/api_constant.dart';
import 'package:movies_app_clean/movies/domain/entities/movie.dart';
import 'package:movies_app_clean/movies/presentation/screens/movie_detail_screen.dart';
import 'package:shimmer/shimmer.dart';

class SeeMoreMovieRowCard extends StatelessWidget {
  final Movie movie;

  const SeeMoreMovieRowCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      from: 20,
      duration: const Duration(milliseconds: 500),
      child: GestureDetector(
        onTap: () => _navigateToMovieDetail(context),
        child: Container(
          height: 140,
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              _buildMoviePoster(),
              Expanded(child: _buildMovieInfo(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoviePoster() {
    return Container(
      width: 100,
      height: 140,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          bottomLeft: Radius.circular(12.0),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12.0),
          bottomLeft: Radius.circular(12.0),
        ),
        child: CachedNetworkImage(
          imageUrl: ApiConstance.imageUrl(movie.backdropPath),
          width: 100,
          height: 140,
          fit: BoxFit.cover,
          placeholder: (context, url) => _buildShimmerPlaceholder(),
          errorWidget: (context, url, error) => _buildErrorWidget(),
        ),
      ),
    );
  }

  Widget _buildMovieInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _truncateTitle(movie.title),
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          _buildRatingRow(),
          const SizedBox(height: 6),
          Flexible(
            child: Text(
              _truncateDescription(movie.overview),
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.grey.shade300,
                height: 1.2,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingRow() {
    return Row(
      children: [
        const Icon(Icons.star, color: Colors.amber, size: 14),
        const SizedBox(width: 4),
        Text(
          movie.voteAverage.toStringAsFixed(1),
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 3,
          height: 3,
          decoration: const BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          _formatReleaseDate(movie.releaseDate),
          style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade400),
        ),
      ],
    );
  }

  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[850]!,
      highlightColor: Colors.grey[800]!,
      child: Container(
        width: 100,
        height: 140,
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.0),
            bottomLeft: Radius.circular(12.0),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: 100,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.grey.shade700,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12.0),
          bottomLeft: Radius.circular(12.0),
        ),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image, color: Colors.grey, size: 30),
          SizedBox(height: 4),
          Text(
            'No Image',
            style: TextStyle(color: Colors.grey, fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _truncateTitle(String title) {
    if (title.length <= 30) return title;
    return '${title.substring(0, 30)}...';
  }

  String _truncateDescription(String description) {
    if (description.length <= 140) return description;
    return '${description.substring(0, 140)}...';
  }

  String _formatReleaseDate(String releaseDate) {
    if (releaseDate.isEmpty) return 'Unknown';
    try {
      final date = DateTime.parse(releaseDate);
      return '${date.year}';
    } catch (e) {
      return 'Unknown';
    }
  }

  void _navigateToMovieDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MovieDetailScreen(id: movie.id)),
    );
  }
}
