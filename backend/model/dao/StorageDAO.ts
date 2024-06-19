import { FirebaseAdapter } from "../adapter/FirebaseAdapter";
import { getDownloadURL, getStorage, ref, uploadBytesResumable } from "firebase/storage";
import { UploadEntity } from "../entities/UploadEntity";

export async function StorageDAO(file: any): Promise<UploadEntity>{
    const app = FirebaseAdapter();
    try {
    const folder = 'thumbnails/';
    const fileName = new Date().getTime()+'_'+file.originalname;
    
    const storage = getStorage(app);

    const refs = ref(storage, folder+fileName);

    const snapshot = await uploadBytesResumable(refs, file.buffer, {
        contentType: "image/jpeg",
      },);

    const link = await getDownloadURL(snapshot.ref);

    return {
        success: true,
        download: link,
    };
    }catch(e){
        return {
            success: false,
            error: e,
        };
    }
}