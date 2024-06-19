import { DatabaseRepository } from '../model/repositories/DatabaseRepository';

export function UploadController() {
  return async (req, res) => {
    const repository = new DatabaseRepository();
    const response = await repository.upload(req.file);
    res.send(response);
  };
}
