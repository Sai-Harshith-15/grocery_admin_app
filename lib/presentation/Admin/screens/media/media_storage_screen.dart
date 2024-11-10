import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../Presentation/widgets/responsive.dart';
import '../../../../constants/app_colors.dart';
import '../../../../controllers/media_controller.dart';
import '../../../widgets/mytext.dart';

class MediaStorageScreen extends StatefulWidget {
  const MediaStorageScreen({super.key});

  @override
  State<MediaStorageScreen> createState() => _MediaStorageScreenState();
}

class _MediaStorageScreenState extends State<MediaStorageScreen> {
  // bool isUploadSectionVisible = false;
  final MediaController mediaController = Get.find<MediaController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeadText(
                  text: "Dashboard / Media",
                  textSize: 20,
                  textWeight: FontWeight.w500,
                ),
                //
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HeadText(
                      text: "Media",
                      textWeight: FontWeight.w700,
                      textSize: Responsive.isDesktop(context) ||
                              Responsive.isDesktopLarge(context)
                          ? 16
                          : 14,
                    ),

                    //
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          mediaController.isUploadSectionVisible.toggle();
                        },
                        icon: Icon(
                          Icons.cloud_upload,
                          color: AppColors.background,
                        ),
                        label: HeadText(
                          text: "Upload Images",
                          textColor: AppColors.background,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondaryGreen,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),

                mediaController.isUploadSectionVisible.value
                    ? Card(
                        color: AppColors.background,
                        elevation: 5,
                        child: Container(
                          height: MediaQuery.of(context).size.height * .4,
                          width: MediaQuery.of(context).size.width * .9,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.folder,
                                  size: 48, color: Colors.black45),
                              const SizedBox(height: 8),
                              const Text(
                                "Drag and Drop Images here",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black54),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {
                                  mediaController.pickImages();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.secondaryGreen),
                                child: HeadText(
                                  text: "Select Images",
                                  textColor: AppColors.background,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                const SizedBox(height: 24),

                //select image folder content

                SizedBox(
                  height: MediaQuery.of(context).size.height * .4,
                  child: Card(
                    elevation: 5,
                    color: AppColors.background,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const HeadText(
                                          text: "Select Folder",
                                          textSize: 16,
                                          textWeight: FontWeight.bold,
                                        ),
                                        const SizedBox(width: 20),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              width: 1,
                                              color: AppColors.primaryBlack,
                                            ),
                                          ),
                                          // Dropdown to select folder
                                          child: DropdownButton<String>(
                                            focusColor: AppColors.background,
                                            dropdownColor: AppColors.background,
                                            underline: const SizedBox(),
                                            value: mediaController
                                                    .selectedFolderForUpload
                                                    .value ??
                                                "Select-Folder",
                                            items: [
                                              if (!mediaController.folderNames
                                                  .contains("Select-Folder"))
                                                const DropdownMenuItem<String>(
                                                  value: "Select-Folder",
                                                  child: HeadText(
                                                    text: "Select Folder",
                                                    textSize: 16,
                                                    textWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ...mediaController.folderNames
                                                  .map((String folder) {
                                                return DropdownMenuItem<String>(
                                                  value: folder,
                                                  child: HeadText(
                                                    text: folder,
                                                    textSize: 16,
                                                    textWeight: FontWeight.w500,
                                                  ),
                                                );
                                              }).toList(),
                                            ],
                                            onChanged:
                                                (String? selectedFolder) {
                                              if (selectedFolder != null) {
                                                mediaController
                                                    .selectedFolderForUpload(
                                                        selectedFolder);
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        mediaController
                                            .removeAllSelectedImages();
                                      },
                                      child: const HeadText(
                                        text: "Remove All",
                                        textColor: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 5),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: MaterialButton(
                                  color: AppColors.secondaryGreen,
                                  onPressed: () async {
                                    await mediaController
                                        .uploadImagesToFolder();
                                  },
                                  minWidth: 100,
                                  child: HeadText(
                                    text: "Upload",
                                    textColor: AppColors.background,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Horizontal scrolling container for images

                          mediaController.isLoading.value
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: 15,
                                    ),
                                    child: CupertinoActivityIndicator(),
                                  ),
                                )
                              : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Wrap(
                                    direction: Axis.horizontal,
                                    spacing: 10.0, // Space between images
                                    children: List<Widget>.generate(
                                      kIsWeb
                                          ? mediaController
                                              .webImageBytesList.length
                                          : mediaController
                                              .selectedImages.length,
                                      (index) {
                                        return Card(
                                          color: AppColors.background,
                                          elevation: 5,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 15),
                                            child: Container(
                                              height: 60,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                color: Colors.grey[300],
                                              ),
                                              child: kIsWeb
                                                  ? Image.memory(
                                                      mediaController
                                                              .webImageBytesList[
                                                          index],
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.file(
                                                      File(mediaController
                                                          .selectedImages[index]
                                                          .path),
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),

                  //media folder content
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * .6,
                    child: Card(
                      color: AppColors.background,
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const HeadText(
                                  text: "Media Folder",
                                  textWeight: FontWeight.bold,
                                  textSize: 16,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          width: 1,
                                          color: AppColors.primaryBlack)),
                                  child: DropdownButton<String>(
                                    focusColor: AppColors.background,
                                    dropdownColor: AppColors.background,
                                    underline: const SizedBox(),
                                    value: mediaController
                                            .selectedFolderForFetch.value ??
                                        "Select-Folder",
                                    items: [
                                      if (!mediaController.folderNames
                                          .contains("Select-Folder"))
                                        const DropdownMenuItem<String>(
                                          value: "Select-Folder",
                                          child: HeadText(
                                            text: "Select Folder",
                                            textSize: 16,
                                            textWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ...mediaController.folderNames
                                          .map((String folder) {
                                        return DropdownMenuItem<String>(
                                          value: folder,
                                          child: HeadText(
                                            text: folder,
                                            textSize: 16,
                                            textWeight: FontWeight.w500,
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                    onChanged: (String? selectedFolder) {
                                      if (selectedFolder != null) {
                                        mediaController.selectedFolderForFetch
                                            .value = selectedFolder;
                                        mediaController.fetchImagesForFolder(
                                            selectedFolder);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Flexible(child: Obx(() {
                              if (mediaController.isLoading.value) {
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: GridView.builder(
                                    itemCount: Responsive.isDesktop(context) ||
                                            Responsive.isDesktopLarge(context)
                                        ? 10
                                        : 5, // Placeholder count
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: Responsive.isDesktop(
                                                  context) ||
                                              Responsive.isDesktopLarge(context)
                                          ? 10
                                          : 5,
                                      mainAxisSpacing: 8,
                                      crossAxisSpacing: 8,
                                    ),
                                    itemBuilder: (context, index) {
                                      return Container(
                                        color: Colors.grey[300],
                                      );
                                    },
                                  ),
                                );
                              }
                              if (mediaController.folderImages.isEmpty) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.folder_open,
                                        size: 100, color: Colors.blue),
                                    HeadText(
                                      text: "No Media Files",
                                      textSize: 18,
                                      textColor: AppColors.primaryBlack,
                                    ),
                                  ],
                                );
                              } else {
                                return Column(
                                  children: [
                                    Flexible(
                                      child: GridView.builder(
                                        itemCount:
                                            mediaController.folderImages.length,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount:
                                              Responsive.isDesktop(context) ||
                                                      Responsive.isDesktopLarge(
                                                          context)
                                                  ? 10
                                                  : 5,
                                          mainAxisSpacing: 8,
                                          crossAxisSpacing: 8,
                                        ),
                                        itemBuilder: (context, index) {
                                          final imageData = mediaController
                                              .folderImages[index];
                                          return Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  showImageUrlDetailsDialogBox(
                                                      imageData.url,
                                                      imageData.name);
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(16),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: CachedNetworkImage(
                                                    height: 50,
                                                    width: 50,
                                                    imageUrl: imageData.url,
                                                    placeholder:
                                                        (context, url) =>
                                                            Shimmer.fromColors(
                                                      baseColor:
                                                          Colors.grey[300]!,
                                                      highlightColor:
                                                          Colors.grey[100]!,
                                                      child: Container(
                                                        width: 50,
                                                        height: 50,
                                                        color: Colors.grey[300],
                                                      ),
                                                    ),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                              //image url name

                                              /* Expanded(
                                                child: HeadText(
                                                  text: imageData.name,
                                                  textSize: 12,
                                                  isTextOverflow: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ), */
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                    //load more
                                    if (!mediaController.isLoading.value &&
                                        mediaController.folderImages.length >=
                                            (mediaController.currentImageBatch *
                                                mediaController.imagesPerPage))
                                      TextButton.icon(
                                        onPressed: () {
                                          if (!mediaController
                                              .isLoadingMore.value) {
                                            mediaController
                                                .fetchImagesForFolder(
                                              mediaController
                                                  .selectedFolderForFetch.value,
                                              loadMore: true,
                                            );
                                          }
                                        },
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.all(15),
                                          backgroundColor:
                                              AppColors.primaryGreen,
                                        ),
                                        icon: mediaController
                                                .isLoadingMore.value
                                            ? SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: AppColors.background,
                                                  strokeWidth: 2.0,
                                                ),
                                              )
                                            : Icon(
                                                Icons.arrow_downward,
                                                color: AppColors.background,
                                              ),
                                        label: mediaController
                                                .isLoadingMore.value
                                            ? HeadText(
                                                text: "Loading...",
                                                textSize: 14,
                                                textColor: AppColors.background,
                                              )
                                            : HeadText(
                                                text: "Load More",
                                                textSize: 14,
                                                textColor: AppColors.background,
                                              ),
                                      ),
                                  ],
                                );
                              }
                            })),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void showImageUrlDetailsDialogBox(
    String imageUrl,
    String name,
  ) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: MediaQuery.of(context).size.height * .5,
              width: MediaQuery.of(context).size.height * .8,
              decoration: BoxDecoration(
                color: AppColors.background,
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        height: 100,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  HeadText(
                    text: "imagesName : $name",
                    textSize: 14,
                    overflow: TextOverflow.ellipsis,
                    isTextOverflow: true,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 3,
                        child: HeadText(
                          text: "imagesName : $imageUrl",
                          textSize: 14,
                          overflow: TextOverflow.ellipsis,
                          isTextOverflow: true,
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            print("copied the imageUrl");
                          },
                          child: Container(
                            /*  height: 40, */
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                                borderRadius: BorderRadius.circular(8)),
                            child: const HeadText(
                              text: "Copy Url",
                              textSize: 14,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      print("url image as be deleted");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: HeadText(
                      textSize: 16,
                      text: "Delete",
                      textColor: AppColors.background,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
