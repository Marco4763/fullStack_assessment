import { DatabaseRepository } from '../model/repositories/DatabaseRepository';

export function UpdateController() {
  return async (req, res) => {
    const repository = new DatabaseRepository();
    const response = await repository.updateThumbnail(req.file, req.params.id);
    res.send(response);
  };
}
