import { FirebaseApp } from 'firebase/app';
import {
  get,
  getDatabase,
  push,
  ref,
  set,
  child,
  startAt,
  endAt,
  query,
  orderByKey,
  DataSnapshot,
  orderByChild,
  equalTo,
  update,
} from 'firebase/database';
import { FirebaseAdapter } from '../adapter/FirebaseAdapter';
import { StorageDAO } from '../dao/StorageDAO';
import { ResponseEntity } from '../entities/ResponseEntity';

export class DatabaseRepository {
  app: FirebaseApp;

  constructor() {
    this.app = FirebaseAdapter();
  }

  async upload(file: any): Promise<ResponseEntity> {
    try {
      const uploadToStorage = await StorageDAO(file);
      if (uploadToStorage.success) {
        let thumbnailList: Object[] = [];

        const thumbnails = await this.getThumbnails();

        if (thumbnails.data !== null) {
          if (thumbnails.data instanceof Array) {
            thumbnailList = thumbnails.data;
          } else {
            thumbnailList.push(thumbnails.data);
          }
        }

        const database = await getDatabase(this.app);
        const databaseRef = ref(database, 'thumbnails');
        const id = await push(databaseRef);
        thumbnailList.push({
          thumbnailId: id.key,
          thumbnail: uploadToStorage.download,
        });

        await set(databaseRef, thumbnailList);
        return {
          success: true,
        };
      } else {
        return {
          success: false,
          data: uploadToStorage,
        };
      }
    } catch (e) {
      return {
        success: false,
        message: e,
      };
    }
  }

  async updateThumbnail(
    file: any,
    thumbnailId: string,
  ): Promise<ResponseEntity> {
    try {
      const database = await getDatabase(this.app);
      const databaseRef = ref(database);
      const values = await get(
        query(
          child(databaseRef, 'thumbnails'),
          orderByChild('thumbnailId'),
          equalTo(thumbnailId),
        ),
      );

      const uploadToStorage = await StorageDAO(file);

      if(uploadToStorage.success){
        values.forEach((thumbnail) => {
            update(thumbnail.ref, {
                thumbnailId: thumbnailId,
                thumbnail: uploadToStorage.download,
              });
        });
      }

      return {
        success: true,
      };
    } catch (e) {
      return {
        success: false,
        message: e,
      };
    }
  }

  async getThumbnails(start?: string, end?: string): Promise<ResponseEntity> {
    try {
      const database = await getDatabase(this.app);
      const databaseRef = ref(database);
      let values: DataSnapshot;
      if (start !== undefined && end !== undefined) {
        values = await get(
          query(
            child(databaseRef, 'thumbnails'),
            orderByKey(),
            startAt(start),
            endAt(end),
          ),
        );
      } else {
        values = await get(child(databaseRef, 'thumbnails'));
      }
      let thumbnailList: Object[] = [];

      if (values.val() instanceof Array) {
        thumbnailList = values.val();
      } else {
        values.forEach((thumbnail) => {
          thumbnailList.push(thumbnail);
        });
      }
      return {
        success: true,
        data: thumbnailList,
      };
    } catch (e) {
      return {
        success: false,
        message: e,
      };
    }
  }
}
